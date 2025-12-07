//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 6/12/2025.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}
