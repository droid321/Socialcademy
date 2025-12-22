//
//  Post.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 6/12/2025.
//

import Foundation


struct Post: Identifiable, Equatable  {
    var title: String
    var content: String
    var author: User
    var isFavorite = false
    var timestamp = Date()
    var id = UUID()
    var imageURL: URL?
    
    func contains (_ string: String) -> Bool {
        let properties = [title, content, author.name].map { $0.lowercased() }
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}

extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, imageURL, timestamp, id
    }
    static let testPost = Post (
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        author: User.testUser
    )
}
