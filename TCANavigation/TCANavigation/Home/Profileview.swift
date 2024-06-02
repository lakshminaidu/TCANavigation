//
//  Profileview.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct Profileview: View {
    @Bindable var store: StoreOf<ProfileReducer>
    var body: some View {
        VStack(alignment: .leading) {
            if store.isLoading {
                ProgressView().tint(.teal)
            } else {
                ScrollView(.vertical) {
                    ForEach(store.photos, id: \.id) { photo in
                        HStack() {
                            AsyncImage(url: URL(string: photo.thumbnailUrl ?? "")) { image in
                                image.resizable().frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                            .aspectRatio(1, contentMode: .fill)
                            .frame(height: 100)
                            Text(photo.title ?? "")
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.teal.cornerRadius(8))
                    }
                }
            }
        }
        .navigationTitle("Photos")
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
struct ProfileReducer {
    @ObservableState
    struct State: Equatable {
        var userid: Int = 1
        var isLoading = false
        var photos: [Photo] = []
    }
    @Dependency(\.apiClient) var apiClient // Apiclient for api calls
    
    enum Action: Equatable {
        case logout
        case fetchdData
        case processResponse([Photo])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchdData:
                state.isLoading = true
                return .run { send in
                    do {
                        let todos: [Photo] = try await self.apiClient.fetch(fromURL: "https://jsonplaceholder.typicode.com/albums/1/photos")
                        await send(.processResponse(todos))
                    } catch {
                        await send(.processResponse([]))
                    }
                }
            case let .processResponse(photos):
                state.photos = photos
                state.isLoading = false
                return .none
            case .logout:
                return .none
            }
        }
    }
}

#Preview {
    Profileview(store: Store(initialState: ProfileReducer.State(), reducer: {
        ProfileReducer()
    }))
}
