//
//  APIRouter.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Alamofire
import Foundation

struct APIRouter: URLRequestConvertible {
    let api: API
    func asURLRequest() throws -> URLRequest {
        guard let url = api.baseURL?.appendingPathComponent(api.path) else {
            throw NetworkError.invalideUrl(url: api.baseURL?.description)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers?.dictionary
        urlRequest.httpBody = api.parameters
        urlRequest.timeoutInterval = 10
        let requestWithParams = try! URLEncoding.default.encode(urlRequest, with: api.query)

        return requestWithParams
    }
}
