//
//  ViewController.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import UIKit
import RxSwift
import SwiftUI

class MainViewController: UIViewController {

    // @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableViewLoadMoreIndicatorView: UIActivityIndicatorView!

    let refreshControl = UIRefreshControl()
    private let viewModel = MainViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        // table view cell register to table view
        let planetNib = UINib(nibName: "PlanetTableViewCell", bundle: nil)
        tableView.register(planetNib, forCellReuseIdentifier: "cell")

        refreshControl.addTarget(self, action: #selector(pullDownRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        viewModel.planets.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PlanetTableViewCell.self)) {(row,item,cell) in
            cell.map(planet: item)

        }.disposed(by: bag)

        viewModel.isLoarding.asObservable().bind {[weak self] value in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                if value {
                    if !self.refreshControl.isRefreshing && self.viewModel.planets.value.count == 0 {
                        self.loadingIndicatorView.startAnimating()
                    }else if(!self.refreshControl.isRefreshing) {
                        self.tableViewLoadMoreIndicatorView.startAnimating()
                    }

                } else {
                    self.refreshControl.endRefreshing()
                    self.tableViewLoadMoreIndicatorView.stopAnimating()
                    self.loadingIndicatorView.stopAnimating()
                }
            }


        }.disposed(by: bag)

        fetchData()

    }

    @objc func pullDownRefresh(_ sender: AnyObject) {
        viewModel.planets.accept([])
        viewModel.currentPage = 1
        viewModel.isPaginationEnd = false
        fetchData()
    }

    func fetchData() {
        viewModel.getPlanets {[weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertController(self).alert(title: error.titile, message: error.message, actions: [UIAlertAction(title: "Button.Ok".localized,
                                                                                                             style: .default),
                                                                                               UIAlertAction(title: "Button.Retry".localized,
                                                                                                             style: .default, handler: { [weak self] _ in
                self?.fetchData()

                                                                              })])
            }
        }
    }


}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(viewModel.planets.value.count - 1 == indexPath.row && !viewModel.isPaginationEnd) {
            fetchData()
        }
    }
}

