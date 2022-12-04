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
    private var _posts: [Post] = []
    private lazy var _postService = PostService()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        fetchPosts()
    }

    private func setupUI() {
        title = Constant.title

        // Navigation bar buttons
        let signOutButton = UIBarButtonItem(title: Constant.signOut, style: .plain, target: self, action: #selector(didTapSignOutButton))
        navigationItem.leftBarButtonItem = signOutButton

        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapCreateButton))
        navigationItem.rightBarButtonItem = createButton

        // Table view
        _tableView.register(UINib(nibName: PostCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PostCell.reuseIdentifier)
    }

    @objc private func didTapCreateButton() {
        let newPostVC = NewPostViewController()
        newPostVC.didCreatePost = {
            [weak self] post in
            self?._posts.append(post)
            self?._tableView.reloadData()
        }

        let navigationController = UINavigationController(rootViewController: newPostVC)

        present(navigationController, animated: true)
    }

    @objc private func didTapSignOutButton() {
        showAlert(message: Constant.signOutConfirm, okTitle: "Yes", okHandler: {
            [weak self] _ in

            AuthenticationService.shared.signOut()
            self?.showAuthentication()
        }, cancelTitle: "No")
    }

    private func fetchPosts() {
        showLoading()

        DispatchQueue.global().async {
            self._postService.fetchPost {
                [weak self] result in

                DispatchQueue.main.async {
                    self?.hideLoading()

                    switch result {
                        case .success(let posts):
                            self?._posts = posts
                            self?._tableView.reloadData()
                        case .failure(let error):
                            print("Fetch post error: \(error)")
                    }
                }
            }
        }
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
        return _posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier) as? PostCell else {
            return UITableViewCell()
        }
        let post = _posts[indexPath.row]
        cell.bindData(post: post)
        cell.willDeletePost = {
            [weak self] in

            self?.showLoading()

            DispatchQueue.global().async {
                self?._postService.deletePost(postId: post.postId) {
                    result in

                    DispatchQueue.main.async {
                        self?.hideLoading()

                        switch result {
                            case .success(_):
                                self?._posts.remove(at: indexPath.row)
                                self?._tableView.reloadData()
                            case .failure(let error):
                                print("Fetch post error: \(error)")
                        }
                    }
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCell.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = _posts[indexPath.row]

        let postDetailVC = PostDetailViewController()
        postDetailVC.post = post

        let navigationController = UINavigationController(rootViewController: postDetailVC)

        present(navigationController, animated: true)
    }
}
