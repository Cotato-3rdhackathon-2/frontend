//
//  KakaoTokenResponseModel.swift
//
//
//  Created by 최준영 on 2024/01/05.
//

import Foundation

// 카카오 -> 로컬
struct KakaoTokenResponseModel: Decodable {
    
    // TODO: 서버 스키마에따라 변경
    var accessToken: String
    var refreshToken: String
    
}

// 로컬에서 사용
public struct KakaoTokenResponseObject {
    
    public var accessToken: String
    public var refreshToken: String
    
}

