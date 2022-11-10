//
//  NetworkError.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
enum NetworkError: Error {
    case invalideUrl(url: String?)
    case offline
    case emptyData
    case timeOutRequest
    case errorOccurredWhileResponding
    case api(value: String!)
}

// MARK: - Error Descriptions
extension NetworkError: LocalizedError, CustomStringConvertible {
    var description: String {
        switch self {
        case .invalideUrl(url: let url):
            if let url = url {
                return "Cannot detect URL \(url)."
            } else {
                return "Cannot detect URL."
            }
        case .offline:
            return "Error.Message.Offline".localized
        case .emptyData:
            return "Error.Message.noData".localized
        case .errorOccurredWhileResponding:
            return "Error.Message.respondError".localized
        case .timeOutRequest:
            return "Error.Message.connectServerError".localized
        case .api(value: let value):
            return value!
        }
    }

    var code: Int {
        switch self {
        case .invalideUrl(url: _):
            return 300
        case .offline:
            return 301
        case .emptyData:
            return 302
        case .timeOutRequest:
            return 303
        case .errorOccurredWhileResponding:
            return 304
        case .api(value: _):
            return 305
        }
    }

    public var failureReason: String? {
        switch self {
        case .invalideUrl(url: let url):
            if let url = url {
                return "Cannot detect URL \(url)."
            } else {
                return "Cannot detect URL."
            }
        case .offline:
            return "Error.Message.Offline".localized
        case .emptyData:
            return "Error.Message.noData".localized
        case .errorOccurredWhileResponding:
            return "Error.Message.respondError".localized
        case .timeOutRequest:
            return "Error.Message.connectServerError".localized
        case .api(value: let value):
            return value
        }
    }

}
