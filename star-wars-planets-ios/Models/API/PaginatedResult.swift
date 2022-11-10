//
//  PaginatedResult.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation
struct PaginatedResult<T:Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
