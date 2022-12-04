//
//  AuthenticationService.swift
//  MiniSocial
//
//  Created by Thao Truong on 15/11/2022.
//

import Foundation
import FirebaseAuth

enum AuthenticationAction {
    case signIn
    case signUp
}

class AuthenticationService {
    static let shared = AuthenticationService()

    private init() {}

    func performAuthentication(action: AuthenticationAction, email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        switch action {
        case .signIn:
            Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        case .signUp:
            Auth.auth().createUser(withEmail: email, password: password, completion: completion)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        UserDefaultsManager.userId = nil
    }
}
