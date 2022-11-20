//
//  LoadingViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 15/11/2022.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var _activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.style = .large
        indicator.color = .white

        indicator.startAnimating()

        // keep it flexible in all directions
        indicator.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]

        return indicator
    }()

    private lazy var _blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.alpha = 0.8

        // same size as parent view
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return blurEffectView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        _blurEffectView.frame = view.bounds
        view.addSubview(_blurEffectView)

        _activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(_activityIndicator)
    }
}
