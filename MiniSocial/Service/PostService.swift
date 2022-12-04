//
//  PostService.swift
//  MiniSocial
//
//  Created by Thao Truong on 23/11/2022.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

enum PostServiceError: Error {
    case userNotFound
    case unknown
}

class PostService {
    func fetchPost(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let userId = UserDefaultsManager.userId else {
            completion(.failure(PostServiceError.userNotFound))
            return
        }

        let db = Firestore.firestore()
        db.collection(userId).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let posts: [Post] = querySnapshot.documents.compactMap {
                    return try? $0.data(as: Post.self)
                }
                completion(.success(posts))
            } else {
                completion(.failure(PostServiceError.unknown))
            }
        }
    }

    func uploadPost(content: String?, image: UIImage?, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let userId = UserDefaultsManager.userId else {
            completion(.failure(PostServiceError.userNotFound))
            return
        }

        // Upload image
        if let image = image, let imageData = image.pngData() {
            let imageName = createImageName(userId: userId)

            let storageRef = Storage.storage().reference().child(imageName)
            storageRef.putData(imageData) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    storageRef.downloadURL {
                        [weak self] url, downloadError in
                        if let url = url {
                            self?.uploadPost(userId: userId, content: content, imageURL: url.absoluteString, completion: completion)
                        } else if let downloadError = downloadError {
                            completion(.failure(downloadError))
                        } else {
                            completion(.failure(PostServiceError.unknown))
                        }
                    }
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

        let db = Firestore.firestore()
        db.collection(userId).document(postId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    private func uploadPost(userId: String, content: String?, imageURL: String?, completion: @escaping (Result<Post, Error>) -> Void) {
        let post = Post(content: content, imageURL: imageURL)
        let db = Firestore.firestore()
        do {
            try db.collection(userId).document(post.postId).setData(from: post, completion: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(post))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }

    private func createImageName(userId: String) -> String {
        let currentTime = String(Date().timeIntervalSince1970)
        return "\(userId)-\(currentTime).png"
    }
}
