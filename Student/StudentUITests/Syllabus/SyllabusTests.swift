//
// This file is part of Canvas.
// Copyright (C) 2019-present  Instructure, Inc.
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

import Foundation
@testable import Core
import TestsFoundation
import XCTest

class SyllabusTests: CoreUITestCase {
    let html = "hello world"
    lazy var course = mock(course: .make(syllabus_body: html))

    func testSyllabusLoad() {
        let assignmentName = "Foobar"
        mockData(
            GetCustomColorsRequest(),
            value: APICustomColors(
                custom_colors: [Context(.course, id: course.id.value).canvasContextID: "#123456", ]
            )
        )

        let assignment = APIAssignment.make(
            description: "hello world",
            name: assignmentName,
            submission: .make()
        )
        mock(assignment: assignment)
        mockData(
            GetCalendarEventsRequest(
                contexts: [Context(.course, id: course.id.value)],
                type: .assignment,
                allEvents: true,
                importantDates: false
            ),
            value: [
                .make(
                    html_url: assignment.html_url,
                    title: assignment.name,
                    type: .assignment,
                    assignment: assignment
                ),
            ]
        )
        mockData(GetCourseSettingsRequest(courseID: course.id.value), value: .make())
        mockData(GetCourseRequest(courseID: course.id.value), value: course)

        show("/courses/\(course.id)/assignments/syllabus")

        app.find(label: "hello world").waitToExist()

        // XCTAssertEqual(NavBar.title.label(), "Course Syllabus")
        // XCTAssertEqual(NavBar.subtitle.label(), course.name)

        app.find(label: "hello world").waitToExist()

        // There's today's date in a request that has no way to be mocked currently
        missingMockBehavior = .allow
        app.swipeLeft()

        let assignmentCell = app.find(labelContaining: assignmentName)
        assignmentCell.tap()
        AssignmentDetails.name.waitToExist(5)

        XCTAssertEqual(navBarColorHex(), "#123456")
    }
}
