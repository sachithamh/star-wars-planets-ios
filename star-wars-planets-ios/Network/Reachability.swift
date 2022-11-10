//
//  Reachability.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import Alamofire

protocol  Reachable {
    func getIsReachable() -> Bool
}

class Reachability: Reachable {
    static var sheard: Reachable = {

        return Reachability(manager: NetworkReachabilityManager())
    }()
    var manager: NetworkReachabilityManager!

    init(manager: NetworkReachabilityManager!) {
        self.manager = manager
        // to do init Listening

    }

    // MARK: - Reachable protocols
    func getIsReachable() -> Bool {
        return manager.isReachable
    }
}
