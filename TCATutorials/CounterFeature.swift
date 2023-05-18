//
//  CounterFeature.swift
//  TCATutorials
//
//  Created by Naoki Muramoto on 2023/05/18.
//

import ComposableArchitecture

struct CounterFeature: ReducerProtocol {
    // MARK: - State
    struct State {
        var count = 0
    }

    // MARK: - Action
    enum Action {
        case tappedDecrementButton
        case tappedIncrementButton
    }

    // MARK: - reduce
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .tappedDecrementButton:
            state.count -= 1
            return .none
        case .tappedIncrementButton:
            state.count += 1
            return .none
        }
    }
}
