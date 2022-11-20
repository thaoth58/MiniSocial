//
//  TimelineViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 20/11/2022.
//

import UIKit

class TimelineViewController: UIViewController {
    private enum Constant {
        static let title = "Timeline"
        static let signOut = "Sign Out"
        static let signOutConfirm = "Do you want to sign out?"
    }

    @IBOutlet private weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        title = Constant.title

        // Navigation bar buttons
        let signOutButton = UIBarButtonItem(title: Constant.signOut, style: .plain, target: self, action: #selector(didTapSignOutButton))
        navigationItem.leftBarButtonItem = signOutButton

        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapCreateButton))
        navigationItem.rightBarButtonItem = createButton
    }

    @objc private func didTapCreateButton() {
        print("Hello")
    }

    @objc private func didTapSignOutButton() {
        showAlert(message: Constant.signOutConfirm, okTitle: "Yes", okHandler: {
            [weak self] _ in

            self?.showAuthentication()
        }, cancelTitle: "No")
    }

    private func showAuthentication() {
        let authenticationVC = AuthenticationViewController()
        setAppRootViewController(authenticationVC, useNavigationController: false)
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Hello"
        return cell
    }
}
