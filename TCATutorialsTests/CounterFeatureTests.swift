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
}
