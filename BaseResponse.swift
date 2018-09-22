//
//  BaseResponse.swift
//  OKala
//
//  Created by Amir Ardalan
//  Copyright © 2017 Mo. All rights reserved.
//

import ObjectMapper


class BaseResponse : Mappable
{

    
    private(set) var success : Bool!
    private(set) var message : String? = ""
    private(set) var errorCode : Int?
    required init?(map: Map) {}

    func mapping(map: Map)
    {
        self.success <- map["success"]
        self.message <- map["message"]
        self.errorCode <- map["errorCode"]
    }
}
