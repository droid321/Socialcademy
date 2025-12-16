//
//  CommentsList.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 9/12/2025.
//

import SwiftUI

// MARK: - CommentsList

struct CommentsList: View {
    @StateObject var viewModel: CommentsViewModel
    @StateObject private var newCommentViewModel: FormViewModel<Comment> // try fix comment text field
    
    init(viewModel: CommentsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._newCommentViewModel = StateObject(
            wrappedValue: viewModel.makeNewCommentViewModel()
        )
    }

    var body: some View {
        Group {
            switch viewModel.comments {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.fetchComments()
                    }
            case let .error(error):
                EmptyListView(
                    title: "Cannot Load Comments",
                    message: error.localizedDescription,
                    retryAction: {
                        viewModel.fetchComments()
                    }
                )
            case .empty:
                EmptyListView(
                    title: "No Comments",
                    message: "Be the first to leave a comment."
                )
            case let .loaded(comments):
                List(comments) { comment in
                    CommentRow(viewModel: viewModel.makeCommentRowViewModel(for: comment))
                }
                .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            NewCommentForm(viewModel: newCommentViewModel)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color(UIColor.systemBackground).shadow(radius: 1))
        }

    }
}

// MARK: - NewCommentForm

private extension CommentsList {
    struct NewCommentForm: View {
        @StateObject var viewModel: FormViewModel<Comment>
        
        var body: some View {
            HStack {
                TextField("Comment", text: $viewModel.value.content)
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Label("Post", systemImage: "paperplane")
                    }
                }
            }
            .alert("Cannot Post Comment", error: $viewModel.error)
            .animation(.default, value: viewModel.isWorking)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct CommentsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Comment.testComment]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    private struct ListPreview: View {
        let state: Loadable<[Comment]>
        
        var body: some View {
            NavigationView {
                CommentsList(viewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: state)))
            }
        }
    }
}
#endif
