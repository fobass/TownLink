//
//  User.viewModel.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/8/25.
//

import Foundation


final class AuthManager: ObservableObject {
    @Published var authState: AuthState = .unauthenticated
    
    
    func isLoggedIn() -> Bool {
        return authState == .loggedIn
    }
}
