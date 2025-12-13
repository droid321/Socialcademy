//
//  AuthView.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 13/12/2025.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        
        if viewModel.isAuthenticated {
                MainTabView()
            } else {
                NavigationView {
                    SignInForm(viewModel: viewModel.makeSignInViewModel()) {
                            NavigationLink("Create Account") {
                                CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel())
                            }
                    }
                }
            }
        }
}


private extension AuthView {
    
    struct CreateAccountForm: View {
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        @Environment(\.dismiss) private var dismiss

        
        var body: some View {
            AuthForm {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.name)
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
            } footer: {
                Button("Create Account", action: viewModel.submit)
                    .buttonStyle(.primary)
            }
            Button("Sign In", action: dismiss.callAsFunction)
                .padding()
                .alert("Cannot Create Account", error: $viewModel.error)
            .onSubmit(viewModel.submit)
            .disabled(viewModel.isWorking)

        }
    }
    
    struct SignInForm<Footer: View>: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            AuthForm {
                TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
            } footer: {
                    Button("Sign In", action: viewModel.submit)
                    .buttonStyle(.primary)
                    footer()
                        .padding()
                }
            .alert("Cannot Sign In", error: $viewModel.error)
                .onSubmit(viewModel.submit)
                .disabled(viewModel.isWorking)

            }
        }
    }
    
    struct AuthForm<Content: View, Footer: View>: View {
        @ViewBuilder let content: () -> Content
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            VStack {
                Text("Socialcademy")
                    .font(.title.bold())
                content()
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(10)
                footer()
            }
            .navigationBarHidden(true)
            .padding()
        }
    }
    
    


