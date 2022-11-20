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

    func showAlert(title: String? = nil, message: String, okTitle: String? = nil, okHandler: ((UIAlertAction) -> Void)? = nil, cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let okTitle = okTitle {
            let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
            alertController.addAction(okAction)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message, cancelTitle: "OK")
    }

    func showLoading() {
        hideLoading()

        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }

        if Self._loadingView == nil {
            Self._loadingView = LoadingView(frame: window.bounds)
        }

        if let loadingView = Self._loadingView {
            window.addSubview(loadingView)
        }
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
