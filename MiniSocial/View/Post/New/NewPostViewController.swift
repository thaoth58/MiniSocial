//
//  NewPostViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 23/11/2022.
//

import UIKit
import PhotosUI

class NewPostViewController: UIViewController {
    private enum Constant {
        static let title = "New Post"
        static let upload = "Upload"
    }

    @IBOutlet private weak var _contentTextView: UITextView!
    @IBOutlet private weak var _imageView: UIImageView!

    private lazy var _imagePicker: PHPickerViewController = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let picker = PHPickerViewController(configuration: config)
        return picker
    }()

    private lazy var _postService = PostService()

    var didCreatePost: ((Post) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = Constant.title

        _contentTextView.layer.cornerRadius = 6.0
        _contentTextView.layer.masksToBounds = true
        _contentTextView.layer.borderWidth = 1.0
        _contentTextView.layer.borderColor = UIColor.black.cgColor

        _imagePicker.delegate = self

        // Navigation bar button
        let uploadButton = UIBarButtonItem(title: Constant.upload, style: .plain, target: self, action: #selector(didTapUploadButton))
        navigationItem.rightBarButtonItem = uploadButton
    }

    @IBAction func didTapChooseImageButton(_ sender: Any) {
        present(_imagePicker, animated: true)
    }

    @objc
    private func didTapUploadButton() {
        showLoading()

        let image = _imageView.image
        let content = _contentTextView.text

        guard image != nil || content != nil else { return }

        DispatchQueue.global().async {
            let compressedImage = image?.compressImage()
            self._postService.uploadPost(content: content, image: compressedImage) {
                [weak self] result in

                DispatchQueue.main.async {
                    self?.hideLoading()

                    switch result {
                        case .success(let post):
                            self?.didCreatePost?(post)
                            self?.dismiss(animated: true)
                        case .failure(let error):
                            print("Upload post error: \(error)")
                            self?.showAlert(message: error.localizedDescription, cancelTitle: "OK")
                    }
                }
            }
        }
    }
}

extension NewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) {
                [weak self] image, _ in

                DispatchQueue.main.async {
                    self?._imageView.image = image as? UIImage
                }
            }
        }
    }
}
