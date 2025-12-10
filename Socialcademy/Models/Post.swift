//
//  Post.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 6/12/2025.
//

import Foundation


struct Post: Identifiable, Equatable, Codable {
    var title: String
    var content: String
    var authorName: String
    var isFavorite = false
    var timestamp = Date()
    var id = UUID()
    
    func contains (_ string: String) -> Bool {
        let properties = [title, content, authorName].map { $0.lowercased() }
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}

extension Post {
    static let testPost = Post (
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        authorName: "Carl SanAgustin"
    )
}
