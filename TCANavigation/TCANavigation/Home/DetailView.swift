//
//  DetailView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    @Bindable var store: StoreOf<DetailReducer>
    var body: some View {
        VStack {
            if store.isLoading {
                ProgressView().tint(.teal)
            } else {
                ScrollView(.vertical) {
                    ForEach(store.todos, id: \.id) { todo in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(todo.title ?? "")
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal.cornerRadius(8))
                    }
                }
            }
        }
        .navigationTitle("Todos")
        .toolbar {
            Button  {
                store.send(.logout)
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right").resizable()
            }
        }
        .task {
            store.send(.fetchdData)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DetailView(store: Store(initialState: DetailReducer.State(), reducer: {
        DetailReducer()
    }))
}


@Reducer
struct DetailReducer {
    @ObservableState
    struct State: Equatable {
        var userid: Int = 1
        var isLoading = false
        var todos: [TodoItem] = []
    }
    @Dependency(\.apiClient) var apiClient // Apiclient for api calls

    enum Action: Equatable {
        case logout
        case fetchdData
        case processResponse([TodoItem])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchdData:
                state.isLoading = true
                return .run { [userid = state.userid] send in
                    do {
						let todos: [TodoItem] = try await self.apiClient.fetchTodos("https://jsonplaceholder.typicode.com/user/\(userid)/todos")
                        await send(.processResponse(todos))
                    } catch {
                        await send(.processResponse([]))
                    }
                }
            case let .processResponse(todos):
                state.todos = todos
                state.isLoading = false
                return .none
            case .logout:
                return .none
            }
        }
    }
}
