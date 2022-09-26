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

protocol ExampleViewModelInputs {
    var viewDidLoad: PassthroughRelay<Void> { get }
    var deleteConferenceDidTap: PassthroughRelay<Void> { get }
}

protocol ExampleViewModelOutputs {
    var conferences: PassthroughRelay<[String]> { get }
    var isLoading: PassthroughRelay<Bool> { get }
}

protocol ExampleViewModelType: ExampleViewModelInputs, ExampleViewModelOutputs, ObservableObject {}

class ExampleViewModel: ExampleViewModelType {
    // MARK: - Inputs

    var inputs: ExampleViewModelInputs { self }
    let viewDidLoad = PassthroughRelay<Void>()
    let deleteConferenceDidTap = PassthroughRelay<Void>()

    // MARK: - Outputs

    var outputs: ExampleViewModelOutputs { self }
    let conferences = PassthroughRelay<[String]>()
    let isLoading = PassthroughRelay<Bool>()

    // MARK: - Properties

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    init(useCase: ExampleUseCase) {
        unowned let unownedSelf = self

        inputs.viewDidLoad
            .flatMap { _ in useCase.getConferences() }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { conferenceList in
                    unownedSelf.outputs.conferences.send(conferenceList)
                }
            )
            .store(in: &subscriptions)

        inputs.deleteConferenceDidTap
            .flatMap { _ in useCase.deleteConference() }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in }
            )
            .store(in: &subscriptions)
    }
}
