//
//  CounterFeatureTests.swift
//  TCATutorialsTests
//
//  Created by Naoki Muramoto on 2023/05/27.
//

import ComposableArchitecture
import XCTest

@testable import TCATutorials

@MainActor
final class CounterFeatureTests: XCTestCase {
    // MARK: - Properties
    let clock = TestClock()

    // MARK: - Method
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        await store.send(.tappedIncrementButton) {
            $0.count = 1
        }
        await store.send(.tappedDecrementButton) {
            $0.count = 0
        }
    }

    func testTimer() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        await store.send(.tappedToggleTimerButton) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTick) {
            $0.count = 1
        }
        await store.send(.tappedToggleTimerButton) {
            $0.isTimerRunning = false
        }
    }

    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        }
        await store.send(.tappedFactButton) {
            $0.isLoading = true
        }
        await store.receive(.factResponse("0 is a good number.")) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
