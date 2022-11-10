//
//  APIError.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
struct APIError: Codable {
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
