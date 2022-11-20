//
//  AuthenticationViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 15/11/2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    @IBOutlet private weak var _emailTextField: UITextField!
    @IBOutlet private weak var _passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func didTapSignInButton(_ sender: Any) {
        doAuthentication(action: .signIn)
    }

    @IBAction func didTapSignUpButton(_ sender: Any) {
        doAuthentication(action: .signUp)
    }

    private func doAuthentication(action: AuthenticationAction) {
        guard let email = _emailTextField.text,
              let password = _passwordTextField.text else { return }

        showLoading()

        AuthenticationService.shared.performAuthentication(action: action, email: email, password: password) {
            [weak self] authResult, error in

            DispatchQueue.main.async {
                self?.hideLoading(completion: {
                    if let error = error {
                        self?.showErrorAlert(message: error.localizedDescription)
                    } else if let authResult = authResult {
                        let timelineVC = TimelineViewController()
                        self?.setAppRootViewController(timelineVC)
                    }
                })
            }
        }
    }
}
