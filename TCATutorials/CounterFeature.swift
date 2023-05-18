//
//  CounterFeature.swift
//  TCATutorials
//
//  Created by Naoki Muramoto on 2023/05/18.
//

import ComposableArchitecture
import SwiftUI

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

extension CounterFeature.State: Equatable {}


struct CounterView: View {
    // MARK: - store
    let store: StoreOf<CounterFeature>

    // MARK: - Body
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(.black.opacity(0.1))
                    .cornerRadius(8)
                HStack {
                    Button {
                        viewStore.send(.tappedDecrementButton)
                    } label: {
                        Text("-")
                            .font(.largeTitle)
                            .padding()
                    } //: Button
                    .background(.black.opacity(0.1))
                    .cornerRadius(8)
                    Button {
                        viewStore.send(.tappedIncrementButton)
                    } label: {
                        Text("+")
                            .font(.largeTitle)
                            .padding()
                    } //: Button
                    .background(.black.opacity(0.1))
                    .cornerRadius(8)
                } //: HStack
            } //: VStack
        } //: WithViewStore
    }
}

struct CounterPreview: PreviewProvider {
    static var previews: some View {
        CounterView(
            store: Store(initialState: CounterFeature.State()) {
                CounterFeature()
            }
        )
    }
}
