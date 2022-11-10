//
//  MainViewModel.swift
//  star-wars-planets-ios
//
//  Created by H A S M Hettiarachchi on 2022-11-10.
//

import RxSwift
import RxCocoa
import Foundation

class MainViewModel {
    let planets = BehaviorRelay<[Planet]>(value: [])
    var currentPage: Int = 1
    var isPaginationEnd: Bool = false
    let isLoarding = BehaviorRelay<Bool>(value: false)

    func getPlanets(completion: @escaping (_ error: AppError?) -> Void ) {
        let api = APIRouter(api: PlanetsAPI.planets(currentPage))
        isLoarding.accept(true)
        NetworkManager.shared.requestDecodable(
            PaginatedResult<Planet>.self, errortype: APIError.self, apiRouter: api
        ) { [weak self] (_ result: PaginatedResult<Planet>?,_ errorResponse: APIError?, _ status: Int?, error)  in
            guard let self = self else{return}
            self.isLoarding.accept(false)
            if let values = result?.results,  error == nil {
                if(result?.next == nil) {
                    self.isPaginationEnd = true
                }
                self.currentPage += 1
                var tempPlanets = self.planets.value
                tempPlanets.append(contentsOf: values)
                self.planets.accept(tempPlanets)
            }

            completion(error)
        }
    }
    
}
