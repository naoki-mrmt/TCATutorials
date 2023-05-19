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
        var fact: String?
        var isLoading = false
    }

    // MARK: - Action
    enum Action {
        case tappedDecrementButton
        case tappedIncrementButton
        case tappedFactButton
    }

    // MARK: - reduce
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .tappedDecrementButton:
            state.count -= 1
            state.fact = nil
            return .none
        case .tappedIncrementButton:
            state.count += 1
            state.fact = nil
            return .none
        case .tappedFactButton:
            state.fact = nil
            state.isLoading = true
            guard let url = URL(string: "http://numbersapi.com/\(state.count)") else {
                return .none
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            state.fact = String(decoding: data, as: UTF8.self)
            state.isLoading = false
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
                Button {
                    viewStore.send(.tappedFactButton)
                } label: {
                    Text("Fact")
                        .font(.largeTitle)
                        .padding()
                } //: Button
                .background(.black.opacity(0.1))
                .cornerRadius(8)

                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
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
