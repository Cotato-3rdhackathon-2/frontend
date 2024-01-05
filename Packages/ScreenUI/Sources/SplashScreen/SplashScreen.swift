//
//  SwiftUIView.swift
//  
//
//  Created by 최준영 on 2024/01/05.
//

import SwiftUI
import GlobalResources

public struct SplashScreen: View {
    
    @EnvironmentObject var mainNavigation: NavigationController<MainScreenDestination>
    
    public init() { }
    
    public var body: some View {
        Image.makeImageFromBundle(bundle: .module, name: "splash", ext: .png)
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .onAppear(perform: {
                
                if let (accessToken, refreshToken) = ApiRequestManager.shared.checkTokenExistsInUserDefaults() {
                    
                    ApiRequestManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
                    
                    mainNavigation.addToStack(destination: .mainScreen)
                    
                } else {
                    
                    mainNavigation.addToStack(destination: .loginScreen)
                    
                }
                
            })
        
    }
}

