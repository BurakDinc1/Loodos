//
//  MoviesResponse.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import ObjectMapper

class MoviesResponse: BaseResponse {
    
    var search: [MoviesData]?
    var totalResult: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.search <- map["Search"]
        self.totalResult <- map["totalResults"]
    }
    
}

class MoviesData: Mappable {
    
    var title, year, imdbID, type, poster: String?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.title <- map["Title"]
        self.year <- map["Year"]
        self.imdbID <- map["imdbID"]
        self.type <- map["Type"]
        self.poster <- map["Poster"]
    }
    
}
