//
//  BaseResponse.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import ObjectMapper

class BaseResponse: Mappable {
    
    var success: String?
    var error: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.success <- map["Response"]
        self.error <- map["Error"]
    }
    
}
