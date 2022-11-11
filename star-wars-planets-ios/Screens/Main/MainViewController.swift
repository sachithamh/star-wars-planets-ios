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
    private let disposeBag = DisposeBag()

    enum SegueIdentifier: String {
       case planetDetail = "planetDetailSegue"
    }

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

        }.disposed(by: disposeBag)

        tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              guard let self = self else {return}

              self.performSegue(withIdentifier: SegueIdentifier.planetDetail.rawValue, sender: self.viewModel.planets.value[indexPath.row])

          }).disposed(by: disposeBag)

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


        }.disposed(by: disposeBag)

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.planetDetail.rawValue {
            if let planet = sender as? Planet, let vc = segue.destination as? PlanetDetailViewController {
                vc.viewModel.planet.accept(planet)
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

