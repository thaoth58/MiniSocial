//
//  TestData.swift
//  MiniSocialTests
//
//  Created by Thao Truong on 04/12/2022.
//

import Foundation
@testable import MiniSocial

class TestData {
    static var posts: [Post] = {
        return [
            Post(content: "1", imageURL: "https://testimage.com"),
            Post(content: "2", imageURL: "https://testimage.com"),
            Post(content: "3", imageURL: "https://testimage.com"),
            Post(content: "4", imageURL: "https://testimage.com")
        ]
    }()
}
