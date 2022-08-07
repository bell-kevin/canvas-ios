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

import SwiftUI

class NoteCellViewModel: CourseDetailsCellViewModel {
    @Environment(\.appEnvironment) private var env
    private let courseID: String
    private let route: URL?

    public init(course: Course) {
        self.courseID = course.id
        self.route = URL(string: "/courses/\(course.id)/notes")

        super.init(courseColor: course.color,
                   iconImage: .noteLine,
                   label: NSLocalizedString("Notes", comment: ""),
                   subtitle: nil,
                   accessoryIconType: .disclosure,
                   tabID: "notes",
                   selectedCallback: nil)
    }

    public override func selected(router: Router, viewController: WeakViewController) {
        super.selected(router: router, viewController: viewController)

        if let url = route {
            router.route(to: url, from: viewController, options: .detail)
        }
    }
}
