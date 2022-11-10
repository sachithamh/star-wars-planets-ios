//
//  PlanetsAPI.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Alamofire
import Foundation

enum PlanetsAPI: API {
    case planets(_ page:Int)
    case planet(_ id:Int)
}

extension PlanetsAPI {
    var host: String {
        return App.shared.getHost()
    }

    var baseURL: URL? {
        return URL(string: host)
    }

    var path: String {
        switch self {
        case .planets(page: _):
            return "/planets"
        case .planet(id: let id):
            return "/planets/\(id)/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .planets(_), .planet(_):
            return .get
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var query: Parameters? {
        switch self {
        case .planets(page: let page):
            return ["page":page]
        default:
            return nil
        }
    }

    var parameters: Data? {
        switch self {
        default:
            return nil
        }
    }

}
