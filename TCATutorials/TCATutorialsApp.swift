//
//  TCATutorialsApp.swift
//  TCATutorials
//
//  Created by Naoki Muramoto on 2023/05/18.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCATutorialsApp: App {
    // MARK: - store
    @State var store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
      }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            CounterView(store: store)
        }
    }
}
