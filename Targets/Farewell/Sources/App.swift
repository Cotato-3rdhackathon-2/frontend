import SwiftUI
import FarewellUI
import GlobalResources

@main
struct MyApp: App {
    
    init() {
        KakaoLoginManager.shared.initKakaoSDKWith(appKey: getKakaoAppKey())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentScreen()
                .onOpenURL { url in
                    
                    KakaoLoginManager.shared.completeSocialLogin(url: url)
                    
                }
        }
    }
    
    private func getKakaoAppKey() -> String {
        let path = Bundle.main.provideFilePath(name: "secrets", ext: "json")
        
        if let contentsOfFile = try? Data(contentsOf: URL(filePath: path)), let decodedContents = try? JSONDecoder().decode(SecretModel.self, from: contentsOfFile) {
            return decodedContents.kakao_native_app_key
        }
        fatalError("failed to get Kakao app key")
    }

    private struct SecretModel: Decodable {
        var kakao_native_app_key: String
    }
    
}
