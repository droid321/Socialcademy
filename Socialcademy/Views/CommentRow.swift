//
//  CommentRow.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 9/12/2025.
//

import SwiftUI

/*struct CommentRow: View {
    @ObservedObject var viewModel: CommentRowViewModel
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(viewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(viewModel.timestamp.formatted())
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text(viewModel.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
        .alert("Cannot Delete Comment", error: $viewModel.error)
        .swipeActions {
            if viewModel.canDeleteComment {
                Button(role: .destructive) {
                    showConfirmationDialog = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this comment?",
            isPresented: $showConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                // Wrap the async call in Task { } to allow await
                Task {
                    await viewModel.deleteComment()
                }
            }
        }
        .alert("Cannot Delete Comment", error: $viewModel.error)
    }
} */

/*struct CommentRow: View {
    @ObservedObject var viewModel: CommentRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(viewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(viewModel.timestamp.formatted())
                    .foregroundColor(.gray)
                    .font(.caption)
            }

            Text(viewModel.content)
                .font(.headline)
        }
        .padding(5)
        .swipeActions(allowsFullSwipe: false) {   // 👈 VERY IMPORTANT
            if viewModel.canDeleteComment {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteComment()
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .alert("Cannot Delete Comment", error: $viewModel.error)
    }
} */

struct CommentRow: View {
    let comment: Comment
    let onDeleteRequest: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(comment.author.name)
                .font(.subheadline)
            Text(comment.content)
        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDeleteRequest()   // ⬅️ just request
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}



/*#if DEBUG
struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(viewModel: CommentRowViewModel(comment: Comment.testComment, deleteAction: {}))
            .previewLayout(.sizeThatFits)
    }
}
#endif
*/

#if DEBUG
struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(
            comment: Comment.testComment,
            onDeleteRequest: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
#endif
