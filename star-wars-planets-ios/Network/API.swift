//
//  API.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Alamofire
import Foundation

protocol API {
    var host: String { get }
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Data? { get }
    var query: Parameters? {get}
}
