//
//  AppRootView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct AppRootView: View {
    @Bindable var store: StoreOf<AppRootReducer>
    var body: some View {
        if store.isLoggedIn {
            HomeView(store: store.scope(state: \.home, action: \.home))
        } else {
            LoginView(store: store.scope(state: \.login, action: \.login))
        }
    }
}


@Reducer
struct AppRootReducer {
    @ObservableState
    struct State: Equatable {
        var login = LoginReducer.State()
        var home = HomeReducer.State()
        var isLoggedIn = false // to launch which screen
    }
    
    enum Action {
        case login(LoginReducer.Action)
        case home(HomeReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .login(\.showHome):
                state.isLoggedIn = true
                return .none
            case .home(\.logout):
                state.isLoggedIn = false
                state.login.username = ""
                state.login.password = ""
                return .none
            default: return .none
            }
        }
        Scope(state: \.login, action: \.login) {
            LoginReducer()
        }
        
        Scope(state: \.home, action: \.home) {
            HomeReducer()
        }
    }
}

