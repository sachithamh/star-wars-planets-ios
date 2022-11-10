//
//  ErrorHelper.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
import Alamofire

class ErrorHelper {

    static func getAppError(error: Error, response: AFDataResponse<Data?>? = nil) -> AppError {

        // map common api error object
        if let data = response?.data {
            let decoder = JSONDecoder()
            if let responseError = try? decoder.decode(APIError.self, from: data) {
                if let errorString = responseError.detail {
                    let error = NetworkError.api(value: errorString)
                    return AppError(title: "Error.Title.ResponseError".localized, status: response?.response?.statusCode, error: error)
                }
            }
        }
        // handle app side network errors
        let nsErr = error as NSError
        switch nsErr.code {
        case 13: // time out
            let error = NetworkError.timeOutRequest
            return AppError(title: "Error.Title.ConnectionError".localized, error: error)

        default:
            // handle request status base error
            if (response?.response?.statusCode ?? 0) >= 400 {
                let error = NetworkError.errorOccurredWhileResponding
                return AppError(title: "Error.Title.ConnectionError".localized, error: error)
            }
            return AppError(title: "Error.Title.ProcessingError".localized, error: error)
        }
    }
}
