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

import Combine

protocol ExampleRepository {
    func getConferences() -> AnyPublisher<[String], Error>
    func deleteConference() -> AnyPublisher<Void, Never>
}

class ExampleRepositoryLive: ExampleRepository {
    // MARK: - Dependencies

    private let remoteDataSource: ExampleDataSource
    private let localDataSource: ExampleDataSource & LocalDataSource

    init(
        remoteDataSource: ExampleDataSource,
        localDataSource: ExampleDataSource & LocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getConferences() -> AnyPublisher<[String], Error> {
        localDataSource.getConferences()
        /*
         .catch { _ in
             unownedSelf.remoteDataSource.getConferences()
                 .sink(
                     receiveCompletion: { _ in },
                     receiveValue: { conferences in
                         unownedSelf.localDataSource.save(object: conferences)
                     })
         }
         */
    }

    func deleteConference() -> AnyPublisher<Void, Never> {
        localDataSource.delete(object: "")
        return Just(()).eraseToAnyPublisher()
    }
}
