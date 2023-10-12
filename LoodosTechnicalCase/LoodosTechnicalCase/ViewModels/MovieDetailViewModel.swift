//
//  MovieDetailViewModel.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 12.10.2023.
//

import Foundation

class MovieDetailViewModel: BaseViewModel {
    
    let movieData: MoviesData
    
    internal init(movieData: MoviesData) {
        self.movieData = movieData
    }
    
}
