//
//  PatoghiError.swift
//  Patoghi Driver
//
//  Created by Amir Ardalani on 4/30/28.
//  Copyright © 2018 Golrang. All rights reserved.
//

import Foundation

enum CustomError: LocalizedError {
    
    case failure(message: String)
    case noValidData
    case notFoundAny
    case noAuthenticate
    case userNotValid
    case timeout
    case notConnected
    
    var localization: String {
        switch self {
        case .failure(let message):
            return message
        case .noValidData:
            return "No VAlid Data"
        case .notFoundAny:
            return "Cant Find Any"
        case .userNotValid:
            return ""
        case .timeout , .notConnected:
            return "Time out Error"
        case .noAuthenticate : return ""
        }
    }
}
