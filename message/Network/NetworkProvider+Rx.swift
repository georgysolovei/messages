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
    private func requestBase<T>(transform: @escaping (Data) -> T?) -> Observable<T> {
        return base.request().rx.responseData()
            .map { (response, data) -> T in
                

                let responseObject = try? JSONDecoder().decode(MessageResponse.self, from: data)
                print(responseObject)
                
                guard let value = transform(data) else {
                    throw NSError(domain: "", code: response.statusCode, userInfo: nil)
                }
                return value
            }a
            .subscribeOn(Scheduler.io)
            .observeOn(Scheduler.io)
    }
    
    func requestData() -> Observable<Data> {
        return requestBase(transform: { $0 })
    }
}
