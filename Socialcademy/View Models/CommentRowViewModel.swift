//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 9/12/2025.
//

import Foundation

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager {
    typealias Action = () async throws -> Void
    
    @Published var comment: Comment
    @Published var error: Error?
    
    var canDeleteComment: Bool { deleteAction != nil }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    private let deleteAction: Action?
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    /*func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    } */
    
    func deleteComment() async {
        guard let deleteAction = deleteAction else { return }
        await withStateManagingTask(perform: deleteAction)
    }
}
