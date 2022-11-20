//
//  UIViewController+Ext.swift
//  MiniSocial
//
//  Created by Thao Truong on 15/11/2022.
//

import Foundation
import UIKit


extension UIViewController {
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    func showLoading() {
        let loadingVC = LoadingViewController()

        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve

        present(loadingVC, animated: true)
    }

    func hideLoading(completion: (() -> Void)? = nil) {
        guard let loadingVC = presentedViewController as? LoadingViewController else { return }
        loadingVC.dismiss(animated: true, completion: completion)
    }

    func setAppRootViewController(_ viewController: UIViewController, useNavigationController: Bool = true) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }

        if useNavigationController {
            let navigationController = UINavigationController(rootViewController: viewController)
            sceneDelegate.setNewRootViewController(navigationController)
        } else {
            sceneDelegate.setNewRootViewController(viewController)
        }
    }
}
