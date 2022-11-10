//
//  AppError.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Foundation

struct AppError {
    var titile: String!
    var message: String!
    var code: Int?
    var error: Error?

    init(title: String, status: Int? = nil, error: Error) {
        let nserror = error as NSError
        self.code = status ?? nserror.code
        self.titile = title
        self.message = nserror.description
        self.error = error
    }
}
