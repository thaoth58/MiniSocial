//
//  PostDetailViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 04/12/2022.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController {
    private enum Constant {
        static let title = "Post Detail"
    }

    @IBOutlet weak var _contentLabel: UILabel!
    @IBOutlet weak var _imageView: UIImageView!

    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = Constant.title

        guard let post = post else { return }

        _contentLabel.text = post.content
        if let imageURL = post.imageURL, let url = URL(string: imageURL) {
            _imageView.kf.setImage(with: url)
        }
    }
}
