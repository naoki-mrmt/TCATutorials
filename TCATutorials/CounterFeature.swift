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
        var isTimerRunning = false
    }

    // MARK: - Action
    enum Action {
        case tappedDecrementButton
        case tappedIncrementButton
        case tappedToggleTimerButton
        case tappedFactButton
        case factResponse(String)
        case timerTick
    }

    enum CancelID { case timer }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact

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
        case .tappedToggleTimerButton:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }
        case .tappedFactButton:
            state.fact = nil
            state.isLoading = true
            return .run { [count = state.count] send in
                try await send(.factResponse(self.numberFact.fetch(count)))
            }
        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none
        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none
        }
    }
}

extension CounterFeature.State: Equatable {}

extension CounterFeature.Action: Equatable {}

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
                    viewStore.send(.tappedToggleTimerButton)
                } label: {
                    Text(viewStore.isTimerRunning ? "Stop timer" : "Start timer")
                        .font(.largeTitle)
                        .padding()
                } //: Button
                .background(.black.opacity(0.1))
                .cornerRadius(8)
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
