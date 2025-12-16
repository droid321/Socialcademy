//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Carl SanAgustin on 9/12/2025.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    @Published var isWorking = false
    private let initialValue: Value

    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
    
    private let action: Action
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.initialValue = initialValue
        self.action = action
    }
    
    nonisolated func submit() {
        Task {
            await handleSubmit()
        }
    }
    
    func reset(to newValue: Value? = nil) {
        value = newValue ?? value // if you want to allow resetting to a new value
    }
    
    /*private func handleSubmit() async {
        isWorking = true
        do {
            try await action(value)
            value = initialValue
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
        isWorking = false
    } */
    
    private func handleSubmit() async {
        isWorking = true
        do {
            try await action(value)
            value = initialValue  // <-- resets TextField automatically
        } catch {
            self.error = error
        }
        isWorking = false
    }
}
