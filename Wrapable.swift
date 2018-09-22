
//
//  File.swift
//  Patoghi Driver
//
//  Created by Amir Ardalani on 7/1/18.
//  Copyright © 2018 Golrang. All rights reserved.
//

import Alamofire
import RxSwift

protocol Wrapable {}

extension Wrapable {

    
    /// all Service call with this ! please if you want to Check the Value check the **response.result.value**
    ///
    /// - Parameters:
    ///   - url: the url of servive
    ///   - param: param need to send
    ///   - method: *Optional* CRUD
    /// - Returns: return the OBservable with generic T that you selected in Call
    func request<T : BaseResponse>(url: String,
                                   param: Parameters? = nil,
                                   method: HTTPMethod = .post)
        -> Observable<Result<T>> {
            print("param for : " , url ,param)
        let observer = PublishSubject<Result<T>>()
        Alamofire.request(url, method: method,
                          parameters: param,
                          encoding: JSONEncoding.default)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                if let code = response.response?.statusCode ,code == 401 {
                    observer.onNext(.failure(PatoghiError.noAuthenticate))
                    observer.onCompleted()
                    return 
                }
                switch response.result {
                case .success(let value):
                    guard value.success else {
                        if ( value.errorCode ?? 0 ) == 10 { // for user not Valid ! !
                            observer.onNext(.failure(PatoghiError.userNotValid))
                            return
                        }
                        else if let message = value.message {
                            observer.onNext(Result.failure(PatoghiError.failure(message: message)))
                        } else {
                            observer.onNext(Result.failure(PatoghiError.noValidData))
                        }
                        observer.onCompleted()
                        return
                    }

                    observer.onNext(Result.success(value))

                case .failure(let error):
                    switch error._code {
                    case  NSURLErrorTimedOut:
                        observer.onNext(Result.failure(PatoghiError.timeout))
                    case NSURLErrorNotConnectedToInternet,NSURLErrorNetworkConnectionLost:
                        observer.onNext(Result.failure(PatoghiError.notConnected))
                    default:
                        observer.onNext(Result.failure(PatoghiError.failure(message: error.localizedDescription)))
                    }
                }
                observer.onCompleted()
        }
        return observer
    }

}
