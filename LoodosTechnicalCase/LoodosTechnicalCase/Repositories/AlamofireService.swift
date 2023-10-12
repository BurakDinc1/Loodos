//
//  AlamofireService.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import Alamofire
import RxSwift

class AlamofireService {
    
    static let shared: AlamofireService = AlamofireService()
    private var manager: SessionManager?
    
    // MARK: Init
    internal init() {
        self.manager = AlamofireService.getSession()
    }
    
    // MARK: Get Session
    private static func getSession() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        configuration.timeoutIntervalForRequest = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let serverTrustManager = ServerTrustPolicyManager(policies: [URLPath.baseURL: .disableEvaluation])
        let alamofireManager = Alamofire.SessionManager(configuration: configuration,
                                                        serverTrustPolicyManager: serverTrustManager)
        return alamofireManager
    }
    
    // MARK: Default URL Component
    private func getURLComponent(path: String = "/", queries: [String: String]) -> String {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = URLPath.urlScheme
        urlComponents.host = URLPath.baseURL
        urlComponents.path = path
        var queryItems: [URLQueryItem] = []
        for (key, value) in queries {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        print("AlamofireService--> \(urlComponents.string!) adresine istek atılıyor...")
        return urlComponents.string!
    }
    
    // MARK: Default Header
    private func getDefaultHeader() -> HTTPHeaders {
        let headers: [String: String] = ["User-Agent": "burak-dinc",
                                         "Content-Type": "application/x-www-form-urlencoded",
                                         "Accept-Encoding": "gzip, deflate, br"]
        return headers
    }
    
    func getMovies(searchKey: String) -> Observable<WsResult<MoviesResponse>> {
        return Observable.create { observer -> Disposable in
            let queries: [String: String] = [
                "s": searchKey,
                "apikey": URLPath.apiKey
            ]
            self.manager?.request(self.getURLComponent(queries: queries), method: .post, parameters: [:], headers: self.getDefaultHeader())
                .fetchServiceWithErrorHandling{ (result: WsResult<MoviesResponse>) in
                    observer.onNext(result)
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }
    
}
