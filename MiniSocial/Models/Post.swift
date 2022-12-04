//
//  Post.swift
//  MiniSocial
//
//  Created by Thao Truong on 23/11/2022.
//

import Foundation

struct Post: Codable {
    var postId: String = UUID().uuidString
    let content: String?
    let imageURL: String?
}
