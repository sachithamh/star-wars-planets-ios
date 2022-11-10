//
//  PlanetTableViewCell.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var planetNameLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var planet: Planet?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        planet?.cancelDownloadImageTask()
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}

            self.coverImageView.image = nil

        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func map(planet: Planet) {
        planetNameLabel.text = planet.name
        climateLabel.text = planet.climate

        loadingIndicator.startAnimating()
        planet.downloadRandomImage {[weak self] data in
            DispatchQueue.main.async {
                guard let self = self else {return}
                if let data = data {
                    self.coverImageView.image = UIImage(data: data)

                }
                self.loadingIndicator.stopAnimating()
            }

        }


    }
    
}
