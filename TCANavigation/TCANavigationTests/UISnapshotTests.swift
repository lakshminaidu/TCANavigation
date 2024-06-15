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
        assertSnapshot(of: uiComponent, as: .image(precision: 812))
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
        let loginView = LoginView(store: loginReducer)
        // show signup
        loginReducer.send(.login)
        assertSnapshot(of: loginView, as: .image)
    }
    
    func testLogin_loginEmptyPassword() {
        let loginReducer = Store(initialState: LoginReducer.State(username: "Demo"), reducer: {
            LoginReducer()
        })
        
        let loginView = LoginView(store: loginReducer)
        loginReducer.send(.login)
        assertSnapshot(of: loginView, as: .image)
    }
    
    func testDetailView() {
        
        let detailReducer = Store(initialState: DetailReducer.State(), reducer: {
            DetailReducer()
        })
        let detailView = DetailView(store: detailReducer)
        // show signup
        assertSnapshot(of: detailView, as: .image(layout: .device(config: ViewImageConfig(size: UIScreen.main.bounds.size))))
    }
    @MainActor
    func testProfile() async {
       let profileStore = Store(initialState: ProfileReducer.State(), reducer: {
            ProfileReducer()
        }, withDependencies: {
            $0.apiClient = .testValue
        })
        profileStore.send(.fetchdData)
        let profile = Profileview(store: profileStore)
        assertSnapshot(of: profile, as: .image(layout: .device(config: ViewImageConfig(size: UIScreen.main.bounds.size))))
    }
    @MainActor
    func testForgotPassword_validation() async {
        let forgotPasswordStore = Store(initialState: ForgotPasswordReducer.State(), reducer: {
            ForgotPasswordReducer()
        })
        let forgotPassword = ForgotPasswordView(store: forgotPasswordStore)
        forgotPasswordStore.send(.updatePassword)
        assertSnapshot(of: forgotPassword, as: .image(layout: .device(config: ViewImageConfig(size: UIScreen.main.bounds.size))))
    }
    
    @MainActor
    func testForgotPassword_validationWithDiffrentPasswords() async {
        let forgotPasswordStore = Store(initialState: ForgotPasswordReducer.State(password: "hello", confirmPassword: "Test"), reducer: {
            ForgotPasswordReducer()
        })
        let forgotPassword = ForgotPasswordView(store: forgotPasswordStore)
        forgotPasswordStore.send(.updatePassword)
        assertSnapshot(of: forgotPassword, as: .image(layout: .device(config: ViewImageConfig(size: UIScreen.main.bounds.size))))
    }
}
