//
//  TCANavigationApp.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCANavigationApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView(store: Store(initialState: AppRootReducer.State.init(), reducer: {
                AppRootReducer()
            }))
        }
    }
}

