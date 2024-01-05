import SwiftUI
import GlobalResources

public struct ContentView: View {
    
    public init() { }
    
    public var body: some View {
        
        Button("카카오 로그인") {
            
            KakaoLoginManager.shared.executeLogin { result in
                switch result {
                case .success(let success):
                    print("")
                case .failure(let failure):
                    
                    print(failure, failure.localizedDescription)
                    
                }
            }
            
        }
        
    }
    
}
