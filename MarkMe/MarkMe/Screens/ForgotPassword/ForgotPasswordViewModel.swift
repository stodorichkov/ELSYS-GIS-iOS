//
//  ForgotPasswordViewModel.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 24.03.22.
//

import Foundation
import FirebaseAuth

class ForgotPasswordViewModel {
    func passwordReset(email: String?) async throws {
        guard let email = email else {
            return
        }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
        catch {
            throw AlertError.forgotPassword(error.localizedDescription)
        }
    }
}
