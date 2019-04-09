//
//  NetworkProvider+Rx.swift
//  message
//
//  Created by Georgy Solovei on 4/8/19.
//  Copyright © 2019 home. All rights reserved.
//

import RxSwift
import Alamofire
import RxAlamofire

extension NetworkProvider: ReactiveCompatible {}


extension Reactive where Base: NetworkProvider {
    private func requestBase(transform: @escaping (Data) -> MessageResponse?) -> Observable<MessageResponse> {
        return base.request().rx.responseData()
            .map { (response, data) -> MessageResponse in
                

                if let responseObject = try? JSONDecoder().decode(MessageResponse.self, from: data) {
//                    PersistencyManager.save(responseObject)
//                    print(responseObject.messages.last?.id)
                    NetworkProvider.shared.token = responseObject.pageToken
                    return responseObject
                } else {
                    
                }
                
                guard let value = transform(data) else {
                    throw NSError(domain: "", code: response.statusCode, userInfo: nil)
                }
                return value
            }
            .subscribeOn(Scheduler.io)
            .observeOn(Scheduler.io)
    }
    
    func requestData() -> Observable<MessageResponse?> {
        return base.request().rx.responseData()
            .map { (response, data) -> MessageResponse? in
                if let messageResponse = try? JSONDecoder().decode(MessageResponse.self, from: data) {
                    NetworkProvider.shared.token = messageResponse.pageToken
                    return messageResponse
                } else { return nil }
        }
    }
}
