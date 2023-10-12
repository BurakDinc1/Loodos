//
//  HomeViewModel.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    
    let moviesList = BehaviorRelay<[MoviesData]>.init(value: [])
    
    // MARK: Get Movies By Name
    func getMoviesByName(search: String) {
        self.isLoad.accept(true)
        self.moviesList.accept([])
        AlamofireService
            .shared
            .getMovies(searchKey: search)
            .subscribe(onNext: {[weak self] (result) in
                switch result {
                case .success(let response):
                    if let list = response.search {
                        self?.moviesList.accept(list)
                    }
                    self?.isLoad.accept(false)
                    break
                case .failure(_):
                    self?.isLoad.accept(false)
                    break
                }
            }, onError: {[weak self] (error) in
                self?.isLoad.accept(false)
            }).disposed(by: self.disposeBag)
    }
    
}
