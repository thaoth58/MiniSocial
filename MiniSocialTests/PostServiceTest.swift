//
//  PostServiceTest.swift
//  MiniSocialTests
//
//  Created by Thao Truong on 04/12/2022.
//

import XCTest
@testable import MiniSocial

class PostServiceTest: XCTestCase {
    var postService: PostService!
    var mockFirebaseManager: MockFirebaseManager!

    override func setUpWithError() throws {
        mockFirebaseManager = MockFirebaseManager()
        postService = PostService(firebaseManager: mockFirebaseManager)
    }

    override func tearDownWithError() throws {
        postService = nil
        mockFirebaseManager = nil
    }

    func testFetchPost_Success() {
        UserDefaultsManager.userId = "test-userid"
        mockFirebaseManager.returnedData = TestData.posts

        let expectation = expectation(description: "Wait for async job")

        postService.fetchPost { result in
            switch result {
            case .success(let posts):
                XCTAssertEqual(posts.count, 4)
            case .failure(_):
                XCTFail("Should not error")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(mockFirebaseManager.getDocumentsWasCalled)
    }

    func testFetchPost_Error_NoUserId() {
        UserDefaultsManager.userId = nil
        let expectation = expectation(description: "Wait for async job")

        postService.fetchPost { result in
            switch result {
            case .success(_):
                XCTFail("Should not success")
            case .failure(let error):
                XCTAssertEqual(error as? PostServiceError, PostServiceError.userNotFound)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(mockFirebaseManager.getDocumentsWasCalled)
    }
}
