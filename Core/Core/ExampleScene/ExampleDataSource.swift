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

protocol ExampleDataSource {
    func getConferences() -> AnyPublisher<[String], Error>
}

class ExampleDataSourceRemote: ExampleDataSource {
    func getConferences() -> AnyPublisher<[String], Error> {
        Future<[String], Error> { promise in
            promise(.success(["0"]))
        }
        .eraseToAnyPublisher()
    }
}

class ExampleDataSourceLocal: ExampleDataSource {
    // MARK: - Dependencies

    private let environment: AppEnvironment

    // MARK: - Private properties

    private lazy var fileSubmissions: Store<LocalUseCase<FileSubmission>> = {
        let scope = Scope(
            predicate: NSPredicate(format: "%K == false", #keyPath(FileSubmission.isHiddenOnDashboard)),
            order: []
        )
        let useCase = LocalUseCase<FileSubmission>(scope: scope)
        return Store(env: environment, useCase: useCase) { [weak self] in
            self?.update()
        }
    }()

    private let resultSubject = PassthroughSubject<[FileSubmission], Error>()

    // MARK: - Init

    init(environment: AppEnvironment = .shared) {
        self.environment = environment
    }

    func getConferences() -> AnyPublisher<[String], Error> {
        resultSubject.map { items in
            let ids = items.map { $0.assignmentID }
            return ids
        }
        .eraseToAnyPublisher()
    }

    private func update() {
        resultSubject.send(fileSubmissions.all)
    }
}
