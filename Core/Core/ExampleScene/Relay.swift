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

class Relay<SubjectType: Subject>: Publisher,
    CustomCombineIdentifierConvertible where SubjectType.Failure == Never {

    typealias Output = SubjectType.Output
    typealias Failure = SubjectType.Failure

    let subject: SubjectType

    init(subject: SubjectType) {
        self.subject = subject
    }

    func send(_ value: Output) {
        subject
            .send(value)
    }

    func receive<S: Subscriber>(subscriber: S)
        where Failure == S.Failure, Output == S.Input {
        subject
            .subscribe(on: DispatchQueue.main)
            .receive(subscriber: subscriber)
    }

}

typealias CurrentValueRelay<Output> = Relay<CurrentValueSubject<Output, Never>>
typealias PassthroughRelay<Output> = Relay<PassthroughSubject<Output, Never>>

extension Relay {

    convenience init<O>(_ value: O)
        where SubjectType == CurrentValueSubject<O, Never> {
        self.init(subject: CurrentValueSubject(value))
    }

    convenience init<O>()
        where SubjectType == PassthroughSubject<O, Never> {
        self.init(subject: PassthroughSubject())
    }

}
