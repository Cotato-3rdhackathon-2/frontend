//
//  KakaoLoginManager.swift
//
//
//  Created by 최준영 on 2024/01/05.
//

import Foundation
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import Alamofire

public class KakaoLoginManager {
    
    typealias TokenResponseCompletion = (OAuthToken?, Error?) -> Void
    
    public static let shared = KakaoLoginManager()
    
    private init() { }
    
    private var isInitialized = false
    
    public func initKakaoSDKWith(appKey: String) {
        KakaoSDK.initSDK(appKey: appKey)
        isInitialized = true
    }
    
    public func completeSocialLogin(url: URL) {
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            let _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    
    // 로그인 실행
    public func executeLogin(completion: @escaping (Result<FarewellTokenObject, NetworkError>) -> Void) {
        guard isInitialized else {
            fatalError("please initialize KakaoSDK first")
        }
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            UserApi.shared.loginWithKakaoTalk {
                
                self.tokenLogicCompletion(oauthToken: $0, error: $1, completion: completion)
                
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {
                
                self.tokenLogicCompletion(oauthToken: $0, error: $1, completion: completion)
                
            }
        }
    }
}

// MARK: - 공용 completion
extension KakaoLoginManager {
    
    func tokenLogicCompletion(oauthToken: OAuthToken?, error: Error?, completion: @escaping (Result<FarewellTokenObject, NetworkError>) -> ()) {
        
        if let error = error {
            
            completion(.failure(.getkakaoTokenError))
            
        }
        else {
            
            if let accessToken = oauthToken?.accessToken, let refreshToken = oauthToken?.refreshToken {
                               // Send accessToken to the server
                ApiRequestManager.shared.sendAccessTokenToServer(accessToken: accessToken, refreshToken: refreshToken) { result in
                    
                    switch result {
                    case .success(let data):
                        
                        completion(.success(data))
                        
                    case .failure(let error):
                        
                        // TODO: 추후 구체화
                        completion(.failure(error))
                        
                    }
                    
                }
            } else {
                
                completion(.failure(.getkakaoTokenError))
                
            }
        }
    }
}
