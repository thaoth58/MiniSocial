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

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Hello"
        return cell
    }
}
