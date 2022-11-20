//
//  UIViewController+Ext.swift
//  MiniSocial
//
//  Created by Thao Truong on 15/11/2022.
//

import Foundation
import UIKit


extension UIViewController {
    static private var _loadingView: LoadingView?

    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    func showLoading() {
        hideLoading()

        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }

        if Self._loadingView == nil {
            Self._loadingView = LoadingView(frame: window.bounds)
        }
        window.addSubview(Self._loadingView!)
    }

    func hideLoading() {
        Self._loadingView?.removeFromSuperview()
        Self._loadingView = nil
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
