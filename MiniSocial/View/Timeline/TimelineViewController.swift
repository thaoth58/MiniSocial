//
//  TimelineViewController.swift
//  MiniSocial
//
//  Created by Thao Truong on 20/11/2022.
//

import UIKit

class TimelineViewController: UIViewController {
    private enum Constant {
        static let title = "Timeline"
    }

    @IBOutlet private weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        title = Constant.title
    }
}
