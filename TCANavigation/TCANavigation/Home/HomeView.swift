//
//  HomeView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>
    @State private var udid = UUID()
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
                .navigationTitle("Home")
                .toolbar {
                    Button  {
                        store.send(.showProfile(1))
                    } label: {
                        Image(systemName: "person.fill").resizable()
                    }
                    
                    Button  {
                        store.send(.logout)
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right").resizable()
                    }
                }
        } destination: { state in
            switch state.case {
            case .detail(let store):
                DetailView(store: store)
            case .profile(let store):
                Profileview(store: store)
            }
        }
        .task {
            store.send(.fetchdData)
        }
    }
    
    @ViewBuilder
    private var content: some View {
		VStack {
			ScrollView(.vertical) {
				LazyVStack(alignment: .leading) {
					ForEach(store.posts, id: \.id) { post in
						HStack {
							VStack(alignment: .leading) {
								Text(post.title ?? "")
									.fontWeight(.bold)
									.multilineTextAlignment(.leading)
								Text(post.body ?? "")
									.font(.caption)
									.multilineTextAlignment(.leading)

							}
							.foregroundColor(.white)
							Spacer()
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.purple.cornerRadius(8))
						.onTapGesture {
							store.send(.showDetail(post.userId))
						}
					}
				}
				.redacted(reason: store.isLoading ? .placeholder : .invalidated)
			}

		}
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HomeView(store: Store(initialState: HomeReducer.State(), reducer: {
            HomeReducer()
        }, withDependencies: {
            $0.apiClient = .testValue
        }))
    }
}


@Reducer
struct HomeReducer {
    @ObservableState
    struct State: Equatable {
        var username: String = ""
        var posts: [Post] = []
        var isLoading = false
        var path = StackState<Destination.State>()
    }
    
    enum Action {
        case logout
        case showDetail(_ userId: Int)
        case showProfile(_ userId: Int)
        case fetchdData
        case processResponse([Post])
        case path(StackAction<Destination.State, Destination.Action>) // navigation
    }
    @Dependency(\.apiClient) var apiClient // Apiclient for api calls
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .showDetail(userId):
                // Navigation start here
                state.path.append(.detail(DetailReducer.State(userid: userId)))
                return .none
            case .showProfile(let userId):
                state.path.append(.profile(ProfileReducer.State(userid: userId)))
                return .none
            case .fetchdData:
                state.isLoading = true
				state.posts = Post.mocks
                return .run { send in
                    do {
                        let posts: [Post] = try await self.apiClient.fetchPosts( "https://jsonplaceholder.typicode.com/posts")
                        await send(.processResponse(posts))
                    } catch {
                        await send(.processResponse([]))
                    }
                }
            case let .processResponse(posts):
                state.posts = posts
                state.isLoading = false
                return .none
            case .logout:
                return .none
            case .path(.element(id: _, action: let action)):
                switch action {
                case .profile(.logout),
                     .detail(.logout):
                    state.path.removeAll()
                    return .run { send in
                        await send(.logout)
                    }
                default: break
                }
                return .none
            case .path(.popFrom(id: _)):
                state.path.removeAll()
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case detail(DetailReducer)
        case profile(ProfileReducer)
    }
}
