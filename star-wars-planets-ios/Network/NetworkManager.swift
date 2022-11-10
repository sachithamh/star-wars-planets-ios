//
//  NetworkManager.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
import Alamofire
import RxSwift

typealias RequestCompletion = (_ data: Data?, _ status: Int?, _ error: AppError?) -> Void

class NetworkManager {
    static var shared: NetworkManager = {
        //for unit test can replace
        return NetworkManager()
    }()
    let retryLimit = 3
    var session: Session
    init(manager: Session = Session.default) {
        self.session = manager
    }

    func request(apiRouter: URLRequestConvertible,
                 completion: @escaping RequestCompletion) {
        guard Reachability.sheard.getIsReachable() == true else {
            let appError = ErrorHelper.getAppError(error: NetworkError.offline, response: nil)
            completion(nil, -1, appError)
            return
        }
        let dataRequest: DataRequest = self.session.request(apiRouter)

        dataRequest.validate().response { (response: AFDataResponse<Data?>) in
            // Logger
            #if DEBUG
            NetworkLogger.shared.log(response: response)
            #endif
            switch response.result {
            case .success(let value):
                completion(value, response.response?.statusCode, nil)
            case .failure(let error):
                let appError = ErrorHelper.getAppError(error: error, response: response)
                completion(nil, response.response?.statusCode, appError)
            }
            return
        }
    }

    func requestDecodable<T: Decodable, E: Decodable>(_ mapType: T.Type, errortype: E.Type,
                                                      apiRouter: URLRequestConvertible,
                                                      completion: @escaping (_ response: T?, _ errorResponse: E? ,
                                                                             _ status: Int?,
                                                                             _ error: AppError?) -> Void) {
        request(apiRouter: apiRouter) { response, status, error in
            guard  error == nil else {
                completion(nil, nil, status, error)
                return
            }
            guard let data = response else {
                let appError = ErrorHelper.getAppError(error: NetworkError.emptyData)
                completion(nil, nil, status, appError)
                return
            }
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(T.self, from: data) {
                completion(response, nil, status, nil)
                return
            }
            if let errorResponse = try? decoder.decode(E.self, from: data) {
                completion(nil, errorResponse, status, nil)
                return
            }
            completion(nil, nil, status, error)
            return
        }
    }

}

