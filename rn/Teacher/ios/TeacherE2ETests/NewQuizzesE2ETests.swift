//
// This file is part of Canvas.
// Copyright (C) 2021-present  Instructure, Inc.
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

import XCTest
import TestsFoundation

class NewQuizzesE2ETests: CoreUITestCase {
    func testNewQuizzesE2E() {
        Dashboard.courseCard(id: "399").waitToExist()
        Dashboard.courseCard(id: "399").tap()
        CourseNavigation.quizzes.tap()
        app.find(label: "Read-only Quiz").tap()
        QuizDetails.launchExternalToolButton.tap()
        app.find(labelContaining: "This is an essay question").waitToExist()
        app.find(labelContaining: "Please don't put text in this box.").waitToExist()
        app.find(labelContaining: "More Quiz Actions").waitToExist()
        app.find(labelContaining: "Toolbar").waitToExist()
        app.find(label: "Done").tap()
        app.find(labelContaining: "This is an essay question").waitToVanish()
        app.find(labelContaining: "Toolbar").waitToVanish()
    }
}
