//
//  WSResult.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation

// MARK: - WsError
class WsError {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

// MARK: - WsResult
enum WsResult<T> {
    case success(T)
    case failure(WsError)
}
