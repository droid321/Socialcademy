//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 7/12/2025.
//

import Foundation
import FirebaseFirestore

protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchAllPosts() async throws -> [Post]
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
    func fetchPosts(by author: User) async throws -> [Post]
    var user: User { get }
}

extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    var user = User.testUser
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func delete(_ post: Post) async throws {
    }
    
    func favorite(_ post: Post) async throws {
    }
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await state.simulate()
    }
    
    func unfavorite(_ post: Post) async throws {
    }
    
    func create(_ post: Post) async throws {}
}
#endif

struct PostsRepository: PostsRepositoryProtocol {
    
    let postsReference = Firestore.firestore().collection("posts_v2")
    let user: User
    let favoritesReference = Firestore.firestore().collection("favorites")
    
     func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }

    
     func fetchAllPosts() async throws -> [Post] {
         return try await fetchPosts(from: postsReference)
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        return try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self)
            .map { post in
                post.setting(\.isFavorite, to: true)
            }
    }

        
    func favorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        try await favoritesReference
            .document(favorite.id)
            .setData(from: favorite)
    }

    
    func unfavorite(_ post: Post) async throws {
        let favoriteID = post.id.uuidString + "-" + user.id
        try await favoritesReference
            .document(favoriteID)
            .delete()
    }

}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

private extension PostsRepository {
    struct Favorite: Identifiable, Codable {
        var id: String {
            postID.uuidString + "-" + userID
        }
        
        let postID: Post.ID
        let userID: User.ID
    }
    
    func fetchFavorites() async throws -> [Post.ID] {
        return try await favoritesReference
            .whereField("userID", isEqualTo: user.id)
            .getDocuments(as: Favorite.self)
            .map(\.postID)
    }
    
    func fetchPosts(from query: Query) async throws -> [Post] {
        let (posts, favorites) = try await (
            query.order(by: "timestamp", descending: true).getDocuments(as: Post.self),
            fetchFavorites()
        )
        return posts.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
    }
    
}

private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
    }
}

private extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: type)
        }
    }
}
