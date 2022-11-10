//
//  NetworkLogger.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
#if DEBUG
import Foundation
import Alamofire

class NetworkLogger {
    static let shared = NetworkLogger()
    func log(response: AFDataResponse<Data?>) {
        print("\n\n==== API Result ====")
        // MARK: - Request
        print("---- Request ----")
        if let request = response.request, let urlRequest = request.urlRequest {
            print("URL: \n\(urlRequest)\n")
            print("Method: \n\(request.method?.rawValue ?? "Nil")\n")
            print("Headers: \n\(request.headers)\n")
            print("httpBody:\n", prettyPrintedString(data: request.httpBody))
        }
        print("---- Response ----")
        if let result = response.response {
            if let taskInterval = response.metrics?.taskInterval {
                print("taskInterval:", taskInterval.duration)
            }
            print("statusCode:", result.statusCode)
            print("httpBody:\n", prettyPrintedString(data: response.data))
        }
        print("==== End API Result ====")
    }

    func prettyPrintedString(data: Data?) -> String {
        guard let value = data else { return "Nil" }
        if let json = try? JSONSerialization.jsonObject(with: value, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return String(data: value, encoding: .utf8) ?? "Nil"
        }
    }
}
#endif

