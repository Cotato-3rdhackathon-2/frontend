//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2024/01/06.
//

import SwiftUI
import GlobalResources

public struct SignInScreen: View {
    
    @EnvironmentObject var mainNavigation: NavigationController<MainScreenDestination>
    
    public init() { }
    
    
    public var body: some View {
        
        VStack {
            
            Spacer(minLength: 0)
            
            Spacer(minLength: 0)
            
            Image.makeImageFromBundle(bundle: .module, name: "splash", ext: .png)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            Spacer(minLength: 0)
            
            Button {
                
                KakaoLoginManager.shared.executeLogin { result in
                    
                    switch result {
                    case .success(let data):
                        
                        ApiRequestManager.shared.setToken(accessToken: data.accessToken, refreshToken: data.refreshToken, isSaveInUserDefaults: true)
                        
                        mainNavigation.addToStack(destination: .mainScreen)
                        
                    case .failure(let failure):
                        
                        return
                        
                    }
                    
                }
                
            } label: {
                Image.makeImageFromBundle(bundle: .module, name: "kakao_button", ext: .png)
                    .resizable()
                    .scaledToFit()
            }
            .frame(height: 60)
            
            Spacer(minLength: 0)
            
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    SignInScreen()
}
