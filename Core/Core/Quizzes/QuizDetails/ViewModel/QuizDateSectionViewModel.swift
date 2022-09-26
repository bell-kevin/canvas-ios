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

public class QuizDateSectionViewModel: DateSectionViewModel {

    @ObservedObject var quiz: Quiz
    public var firstAssignmentDate: AssignmentDate?
    public var isButton = false

    public init(quiz: Quiz) {
        self.quiz = quiz
        firstAssignmentDate = quiz.allDates.first
    }

    public var hasMultipleDueDates: Bool {
        quiz.allDates.count > 1
    }

    public var dueAt: Date? {
        quiz.dueAt ?? firstAssignmentDate?.dueAt
    }

    public var lockAt: Date? {
        firstAssignmentDate?.lockAt ?? quiz.lockAt
    }

    public var unlockAt: Date? {
        firstAssignmentDate?.unlockAt ?? quiz.unlockAt
    }

    public func buttonTapped(router: Router, viewController: WeakViewController) {}
}
