//
//  PlanetDetailViewController.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-11.
//

import UIKit
import RxSwift

class PlanetDetailViewController: UIViewController {

    @IBOutlet weak var coverImageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coverImageView: UIImageView!


    @IBOutlet weak var planetNameInfoLabel: UILabel!
    @IBOutlet weak var climateInfoLabel: UILabel!
    @IBOutlet weak var orbitalPeriodInfoLabel: UILabel!
    @IBOutlet weak var gravityInfoLabel: UILabel!

    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var orbitalPeriodLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!

    let viewModel = PlanetDetailViewModel()
    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    deinit {
        viewModel.planet.value?.cancelDownloadImageTask()
    }

    private func setup() {
        planetNameInfoLabel.text = "screen.planetDetail.planetNameInfo".localized
        climateInfoLabel.text = "screen.planetDetail.climateInfo".localized
        orbitalPeriodInfoLabel.text = "screen.planetDetail.orbitalPeriodInfo".localized
        gravityInfoLabel.text = "screen.planetDetail.gravityInfo".localized

        viewModel.planet.asObservable().bind {[weak self] planet in
            guard let self = self else{return}
            if let planet = planet {
                self.title = planet.name
                self.planetNameLabel.text =  ": " + planet.name
                self.climateLabel.text = ": " + planet.climate
                self.orbitalPeriodLabel.text = ": " + planet.orbitalPeriod
                self.gravityLabel.text = ": " + planet.gravity

                self.coverImageLoadingIndicator.startAnimating()
                planet.downloadRandomImage {[weak self] data in
                    DispatchQueue.main.async {
                        guard let self = self else {return}
                        if let data = data {
                            self.coverImageView.image = UIImage(data: data)

                        }
                        self.coverImageLoadingIndicator.stopAnimating()
                    }

                }
            }
        }.disposed(by: disposeBag)
    }

}
