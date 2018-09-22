//
//  Errorable.swift
//  Tarabar
//
//  Created by Amir Ardalan on 7/4/18.
//  Copyright © 2018 Golrang. All rights reserved.
//

import Foundation
import RxSwift

enum Exception {
    case noAuthenticate
    case failure(message: String)
}

protocol Errorable {
    var onError: PublishSubject<Exception> {get set}
}

extension Errorable {
    
    func catchError(error: Error) {
        let e = error as! CustomError
        switch e {
        case .noAuthenticate: self.onError.onNext(.noAuthenticate)
        default: self.onError.onNext(.failure(message: (error as! CustomError).localization))
        }
    }
}
