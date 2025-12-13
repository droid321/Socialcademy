//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 13/12/2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}

#Preview {
    ProfileView()
}
