//
//  PostCell.swift
//  MiniSocial
//
//  Created by Thao Truong on 04/12/2022.
//

import UIKit
import Kingfisher

class PostCell: UITableViewCell {
    static let reuseIdentifier = "PostCell"
    static let height: CGFloat = 130

    @IBOutlet private weak var _imageView: UIImageView!
    @IBOutlet private weak var _contentLabel: UILabel!

    var willDeletePost: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func bindData(post: Post) {
        if let imageURL = post.imageURL, let url = URL(string: imageURL) {
            _imageView.isHidden = false
            _imageView.kf.setImage(with: url)
        } else {
            _imageView.isHidden = true
        }
        _contentLabel.text = post.content
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        willDeletePost?()
    }
}
