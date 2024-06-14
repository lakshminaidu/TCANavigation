//
//  AppButtonTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 14/06/24.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import TCANavigation


final class UISnapshotTests: XCTestCase {

    func testAppButton() {
        let uiComponent = AppButton()
        assertSnapshot(of: uiComponent, as: .image)
    }
    
    func testAppField_placeHolder() {
        let uiComponent = AppField(placeHolder: "Enter name", text: .constant(""))
        assertSnapshot(of: uiComponent, as: .image)
    }
    
    func testAppField_placeHoldeandtextandsecure() {
        let uiComponent = AppField(placeHolder: "Enter name", text: .constant("Hello"), isSecure: true)
        assertSnapshot(of: uiComponent, as: .image)
    }
    
    func testRoot_WhenLoginFalse() {
        let login = AppRootView(store: Store(initialState: AppRootReducer.State(), reducer: {
            AppRootReducer()
        }))
        assertSnapshot(of: login, as: .image)
    }
    
    
    func testRootAsHome_WhenLoginTrue() {
        let home = AppRootView(store: Store(initialState: AppRootReducer.State(isLoggedIn: true), reducer: {
            AppRootReducer()
        }))
        assertSnapshot(of: home, as: .image)
    }
    
    func testRootAsHomeWithData_WhenLoginTrue() {
        let home = AppRootView(store: Store(initialState: AppRootReducer.State(home: HomeReducer.State(posts: Post.mocks), isLoggedIn: true), reducer: {
            AppRootReducer()
        }, withDependencies: {
            $0.apiClient = .testValue
        }))
        assertSnapshot(of: home, as: .image)
    }
    
    func testLogin_WithSignUpAction() {
        let store = Store(initialState: AppRootReducer.State(), reducer: {
            AppRootReducer()
        })
        // show signup
        store.send(.login(.showSignup))
        let login = AppRootView(store: store)
        assertSnapshot(of: login, as: .image)
    }
    
    func testLogin_loginEmptyUsernameAndPassword() {
        let loginReducer = Store(initialState: LoginReducer.State(), reducer: {
            LoginReducer()
        })
        let loginView =  LoginView(store: loginReducer)
        // show signup
        loginReducer.send(.login)
        assertSnapshot(of: loginView, as: .image)
    }
    
    func testLogin_loginEmptyPassword() {
        let loginReducer = Store(initialState: LoginReducer.State(username: "Demo"), reducer: {
            LoginReducer()
        })
        
        let loginView =  LoginView(store: loginReducer)
        // show signup
        loginReducer.send(.login)
        assertSnapshot(of: loginView, as: .image)
    }
}
