//
//  PostList.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 7/12/2025.
//

import SwiftUI

struct PostsList: View {
    @StateObject var viewModel: PostsViewModel
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    
    var body: some View {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Posts",
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.fetchPosts()
                        }
                    )
                case .empty:
                    EmptyListView(
                        title: "No Posts",
                        message: "There aren’t any posts yet."
                    )
                case let .loaded(posts):
                    ScrollView {
                        ForEach(posts) { post in
                            if searchText.isEmpty || post.contains(searchText) {
                                PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                            }
                        }
                        .searchable(text: $searchText)
                        .animation(.default, value: posts)
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        .sheet(isPresented: $showNewPostForm) {
            NewPostForm(viewModel: viewModel.makeNewPostsViewModel())
        }
    }
}

extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.loaded(value1), .loaded(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            NavigationView {
                PostsList(viewModel: viewModel)
            }
        }
    }
}
#endif
