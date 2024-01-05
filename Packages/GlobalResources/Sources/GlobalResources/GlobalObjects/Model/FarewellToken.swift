//
//  FarewellTokenObject.swift
//
//
//  Created by 최준영 on 2024/01/05.
//

import Foundation


// 카카오토큰 -> 서버
struct FarewellTokenRequestModel: Encodable {
    
    // TODO: 서버 스키마에따라 변경
    var accessToken: String
    var refreshToken: String
    
}

// 서버(farewell토큰) -> 로컬
struct FarewellTokenResponseModel: Decodable {
    
    // TODO: 서버 스키마에따라 변경
    var accessToken: String
    var refreshToken: String
    
}

// 로컬에서 사용
public struct FarewellTokenObject {
    
    // TODO: 서버 스키마에따라 변경
    public var accessToken: String
    public var refreshToken: String
    
}
