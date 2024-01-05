import SwiftUI
import GlobalResources
import SplashScreen
import SignInScreen

public struct ContentScreen: View {
    
    @StateObject private var mainNavigation = NavigationController<MainScreenDestination>()
    
    public init() { }
    
    public var body: some View {
        
        NavigationStack(path: $mainNavigation.navigationStack) {
            
            
            SplashScreen()
            
                .navigationDestination(for: MainScreenDestination.self) { destination in
                    switch destination {
                    case .loginScreen:
                        SignInScreen()
                    case .mainScreen:
                        Text("mainScreen")
                    }
                }
            
        }
        .environmentObject(mainNavigation)
        
    }
    
}
