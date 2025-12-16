//
//  CommentsViewModel.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 9/12/2025.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: Loadable<[Comment]> = .loading
    
    private let commentsRepository: CommentsRepositoryProtocol
    
    init(commentsRepository: CommentsRepositoryProtocol) {
        self.commentsRepository = commentsRepository
    }
    
    func fetchComments() {
        Task {
            do {
                comments = .loaded(try await commentsRepository.fetchComments())
            } catch {
                print("[CommentsViewModel] Cannot fetch comments: \(error)")
                comments = .error(error)
            }
        }
    }
    
    /*func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment>(
            initialValue: Comment(content: "", author: commentsRepository.user),
            action: { [weak self] comment in
                try await self?.commentsRepository.create(comment)
                self?.comments.value?.insert(comment, at: 0)
            }
        )
    } */
    
    func makeNewCommentViewModel() -> FormViewModel<Comment> {
        return FormViewModel<Comment>(
            initialValue: Comment(content: "", author: commentsRepository.user),
            action: { [weak self] comment in
                guard let self else { return }

                // Make a fresh comment instance for storage
                let newComment = Comment(
                    content: comment.content,
                    author: comment.author
                )

                try await self.commentsRepository.create(newComment)

                // Update published property so SwiftUI sees the change
                if case var .loaded(currentComments) = self.comments {
                    currentComments.insert(newComment, at: 0)
                    self.comments = .loaded(currentComments)
                }
            }
        )
    }


    
    func makeCommentRowViewModel(for comment: Comment) -> CommentRowViewModel {
        let deleteAction = { [weak self] in
            try await self?.commentsRepository.delete(comment)
            self?.comments.value?.removeAll { $0.id == comment.id }
        }
        return CommentRowViewModel(
            comment: comment,
            deleteAction: commentsRepository.canDelete(comment) ? deleteAction : nil
        )
    }
}
