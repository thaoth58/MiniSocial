//
//  PostService.swift
//  MiniSocial
//
//  Created by Thao Truong on 23/11/2022.
//

import Foundation
import UIKit

enum PostServiceError: Error, Equatable {
    case userNotFound
}

class PostService {
    private let _firebaseManager: FirebaseManagerProtocol

    init(firebaseManager: FirebaseManagerProtocol = FirebaseManager()) {
        _firebaseManager = firebaseManager
    }

    func fetchPost(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let userId = UserDefaultsManager.userId else {
            completion(.failure(PostServiceError.userNotFound))
            return
        }

        _firebaseManager.getDocuments(collection: userId, completion: completion)
    }

    func uploadPost(content: String?, image: UIImage?, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let userId = UserDefaultsManager.userId else {
            completion(.failure(PostServiceError.userNotFound))
            return
        }

        // Upload image
        if let image = image, let imageData = image.pngData() {
            let imageName = createImageName(userId: userId)

            _firebaseManager.uploadData(name: imageName, data: imageData) { [weak self] result in
                switch result {
                case .success(let url):
                    self?.uploadPost(userId: userId, content: content, imageURL: url.absoluteString, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            uploadPost(userId: userId, content: content, imageURL: nil, completion: completion)
        }
    }

    func deletePost(postId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userId = UserDefaultsManager.userId else {
            completion(.failure(PostServiceError.userNotFound))
            return
        }

        _firebaseManager.deleteDocument(collection: userId, document: postId, completion: completion)
    }

    private func uploadPost(userId: String, content: String?, imageURL: String?, completion: @escaping (Result<Post, Error>) -> Void) {
        let post = Post(content: content, imageURL: imageURL)
        _firebaseManager.uploadDocument(collection: userId, document: post.postId, object: post, completion: completion)
    }

    private func createImageName(userId: String) -> String {
        let currentTime = String(Date().timeIntervalSince1970)
        return "\(userId)-\(currentTime).png"
    }
}
