//
//  FirebaseManager.swift
//  MiniSocial
//
//  Created by Thao Truong on 04/12/2022.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirebaseManagerError: Error {
    case unknown
}

protocol FirebaseManagerProtocol {
    func getDocuments<T: Codable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void)
    func uploadData(name: String, data: Data, completion: @escaping (Result<URL, Error>) -> Void)
    func deleteDocument(collection: String, document: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func uploadDocument<T: Codable>(collection: String, document: String, object: T, completion: @escaping (Result<T, Error>) -> Void)
}

class FirebaseManager: FirebaseManagerProtocol {
    private let _db = Firestore.firestore()

    func getDocuments<T: Codable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        _db.collection(collection).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let querySnapshot = querySnapshot {
                let objects: [T] = querySnapshot.documents.compactMap {
                    return try? $0.data(as: T.self)
                }
                completion(.success(objects))
            } else {
                completion(.failure(FirebaseManagerError.unknown))
            }
        }
    }

    func uploadData(name: String, data: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child(name)
        storageRef.putData(data) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, downloadError in
                    if let url = url {
                        completion(.success(url))
                    } else if let downloadError = downloadError {
                        completion(.failure(downloadError))
                    } else {
                        completion(.failure(FirebaseManagerError.unknown))
                    }
                }
            }
        }
    }

    func deleteDocument(collection: String, document: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        _db.collection(collection).document(document).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    func uploadDocument<T: Codable>(collection: String, document: String, object: T, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            try _db.collection(collection).document(document).setData(from: object, completion: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(object))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
}
