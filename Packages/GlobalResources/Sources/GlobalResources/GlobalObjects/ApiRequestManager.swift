//
//  ApiRequestManager.swift
//
//
//  Created by 최준영 on 2024/01/05.
//

import Foundation
import Alamofire

public class ApiRequestManager {
    
    public var farewellAccessToken: String!
    public var farewellRefreshToken: String!
    
    public static var shared: ApiRequestManager = .init()
    
    private init() { }
    
    // UserDefualts
    let kAccessTokenKey = "farewellAccessToken"
    let kRefreshTokenKey = "farewellRefreshToken"
    
}

// MARK: - 로컬에 저장된 토큰 체크
extension ApiRequestManager {
    
    // 로컬에 토큰 저장
    public func setToken(accessToken: String, refreshToken: String, isSaveInUserDefaults: Bool = false) {
        
        self.farewellAccessToken = accessToken
        self.farewellRefreshToken = refreshToken
        
        if isSaveInUserDefaults {
            
            UserDefaults.standard.set(accessToken, forKey: self.kAccessTokenKey)
            UserDefaults.standard.set(refreshToken, forKey: self.kRefreshTokenKey)

        }
        
    }
    
    // 로컬 토큰 존재확인
    public func checkTokenExistsInUserDefaults() -> (String, String)? {
        
        if let accessToken = UserDefaults.standard.string(forKey: self.kAccessTokenKey), let refreshToken = UserDefaults.standard.string(forKey: self.kRefreshTokenKey) {
            
            return (accessToken, refreshToken)
            
        }
        
        return nil
        
    }
    
}

// MARK: - API 요청
enum ApiInternalError: Error {
    
    case apiUrlError(discription: String)
    
}

public extension ApiRequestManager {
    
    enum FarewellApi: CaseIterable {
        
        case getFarewellToken
        
        // TODO: API 베이스 url
        static let baseUrl = ""
        
        public func getApiUrl() throws -> URL {
            
            var additinalUrl = ""
            
            switch self {
            case .getFarewellToken:
                additinalUrl = ""
            @unknown default:
                throw ApiInternalError.apiUrlError(discription: "주소가 지정되지 않은 API가 있습니다.")
            }
            
            guard let url = URL(string: Self.baseUrl + additinalUrl) else {
                throw ApiInternalError.apiUrlError(discription: "잘못된 문자열구성으로 URL을 생성할 수 없습니다.")
            }
            
            return url
            
        }
        
    }
    
}

// MARK: - 서버에 카카오 토큰 전송
public extension ApiRequestManager {
    
    func sendAccessTokenToServer(accessToken: String, refreshToken: String, completion: @escaping (Result<FarewellTokenObject, NetworkError>) -> Void) {
        
        let url = try! FarewellApi.getFarewellToken.getApiUrl()
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        // TODO: 서버 형식에 따라 변경
        let parameters: [String: Any] = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { self.tokenRequestCompletionHandler(response: $0, completion: completion) }
        
    }
    
    private func tokenRequestCompletionHandler(response: AFDataResponse<Data>, completion: (Result<FarewellTokenObject, NetworkError>) -> Void) {
        
        switch response.result {
        case .success(let data):
            
            if let decoded = try? JSONDecoder().decode(FarewellTokenResponseModel.self, from: data) {
                
                let tokenData = FarewellTokenObject(accessToken: decoded.accessToken, refreshToken: decoded.refreshToken)
                
                completion(.success(tokenData))
                
                return
                
            }
            
            // 서버로 부터 잘못된 데이터 전송 or 잘못된 모델
            completion(.failure(.wrongFarewellTokenModel))
            
        case .failure(let error):
            
            // TODO: 너무 잦은 리프래쉬 요청시 해결
            
            completion(.failure(.serverError))
            
        }
        
    }
    
}
