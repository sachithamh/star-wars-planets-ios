//
//  Planet.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
class Planet: Codable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents, films: [String]
    let created, edited: String
    let url: String
    var imageData:Data?
    private var downloadImageTask:URLSessionDataTask?

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }

    func cancelDownloadImageTask() {
        downloadImageTask?.cancel()
    }
    func downloadRandomImage(completion: @escaping (_ data: Data?)-> Void){
        if let data = imageData {
            completion(data)
            return
        } 

      downloadImageTask =   URLSession.shared.dataTask(with: App.shared.randomImages(height: 200, ratio: 2)) { [weak self] data, _, _ in
          guard let self = self  else {return}
            if let data = data {
                self.imageData = data
            }
            completion(data)
        }
        downloadImageTask?.resume()
    }
}
