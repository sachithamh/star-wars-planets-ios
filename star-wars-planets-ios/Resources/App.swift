//
//  App.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import UIKit

class App {
    static let shared = App()
    func getHost() -> String {
        let serverUrl = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String

        return serverUrl!
    }

    func randomImages(height: Int, ratio: Int) -> URL {
        return URL(string: "https://picsum.photos/\(height * ratio)/\(height)")!
    }
}
