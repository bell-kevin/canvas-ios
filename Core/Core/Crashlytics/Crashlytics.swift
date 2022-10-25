//
// This file is part of Canvas.
// Copyright (C) 2022-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Firebase
import Foundation
import FirebaseRemoteConfig

public class Crashlytics: NSObject {
    public static var shared = Crashlytics()

    public func initialize(plistPath: String) {
        guard !testing else {
            setupDebugCrashLogging()
            return
        }

        guard
            let options = FirebaseOptions(contentsOfFile: plistPath),
            options.apiKey != nil else {
            return
        }
        FirebaseApp.configure(options: options)
        configureRemoteConfig()
    }

    public func record(error: Error) {
        Firebase.Crashlytics.crashlytics().record(error: error)
    }

    private func setupDebugCrashLogging() {
        NSSetUncaughtExceptionHandler { exception in
            print("CRASH: \(exception)")
            print("Stack Trace:")
            for symbol in exception.callStackSymbols {
                print("  \(symbol)")
            }
        }
    }

    private func configureRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetch(withExpirationDuration: 0) { _, _ in
            remoteConfig.activate { _, _ in
                let keys = remoteConfig.allKeys(from: .remote)
                for key in keys {
                    guard let feature = ExperimentalFeature(rawValue: key) else { continue }
                    let value = remoteConfig.configValue(forKey: key).boolValue
                    feature.isEnabled = value
                    Firebase.Crashlytics.crashlytics().setCustomValue(value, forKey: feature.userDefaultsKey)
//                    Analytics.setUserProperty(value ? "YES" : "NO", forName: feature.rawValue)
                }
            }
        }
    }
}
