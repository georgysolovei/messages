//
//  NetworkProvider.swift
//  message
//
//  Created by Georgy Solovei on 4/8/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkProvider {
    static var shared = NetworkProvider()
    var sessionManager: SessionManager
    public let requestTimeoutInterval: TimeInterval = 20
    
    var token = ""

    private let url = "http://message-list.appspot.com/messages"
    let baseUrl = "http://message-list.appspot.com/"
    
    private init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeoutInterval
        sessionManager = SessionManager(configuration: configuration)
    }
    
    func request() -> DataRequest {
        let params: [String : Any] = ["pageToken": token,
                                          "limit": 100]
        return sessionManager.request(url, parameters: params)
    }
}



