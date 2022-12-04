//
//  MockFirebaseManager.swift
//  MiniSocialTests
//
//  Created by Thao Truong on 04/12/2022.
//

import Foundation
@testable import MiniSocial

class MockFirebaseManager: FirebaseManagerProtocol {
    var getDocumentsWasCalled = false
    var uploadDataWasCalled = false
    var deleteDocumentWasCalled = false
    var uploadDocumentWasCalled = false

    var returnedData: Any?

    func getDocuments<T: Codable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        getDocumentsWasCalled = true
        if let returnedData = returnedData as? Array<T> {
            completion(.success(returnedData))
        }
    }
    
    func uploadData(name: String, data: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        uploadDataWasCalled = true
    }
    
    func deleteDocument(collection: String, document: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        deleteDocumentWasCalled = true
    }
    
    func uploadDocument<T: Codable>(collection: String, document: String, object: T, completion: @escaping (Result<T, Error>) -> Void) {
        uploadDocumentWasCalled = true
    }
}
