//
//  Planet.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
class Planet: Codable {
    let name, orbitalPeriod: String
    let climate, gravity: String
    var imageData:Data?
    private var downloadImageTask:URLSessionDataTask?

    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case climate, gravity
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
