//
//  Login.View.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/8/25.
//
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class GoogleSignInManager: NSObject, ObservableObject {
    
    override init() {
        super.init()
    }
    
    func signIn() {
        guard let rootViewController = UIApplication.shared.rootViewController else {
            print("Could not find root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult else {
                // Inspect error
                print("Error signing in: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // If sign-in succeeded, proceed with app's logic
            print("Successfully signed in with Google:")
        }
    }
}


extension UIApplication {
    var rootViewController: UIViewController? {
        return self.windows.first?.rootViewController
    }
}




struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var location: LocationDataManager
    @State private var isAnimating = false
    @State private var progress: Float = 20
    @State private var isLoading = true
    var body: some View {
        ZStack{
            Image("town_link_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.5)
                )
            VStack(spacing: 10){
                Spacer()
                Text("TownLink")
                    .font(.custom("TrebuchetMS-Bold", size: 36))
                    .foregroundColor(Color.white)
                Text("Your Local Connection Hub...")
                    .font(.custom("TrebuchetMS", size: 16))
                    .foregroundColor(Color.white)
                Spacer()
                
            
                Spacer()
                VStack(spacing: 10){
                    
                    VStack{
                        Button(action: {
                            handleGoogleSignInButton()
                        }, label: {
                            HStack{
                                Image(systemName: "g.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                    .padding(.leading, 10)
                                Text("LOG IN WITH GOOGLE")
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                            }
                        })
                        .background(.white)
                        .cornerRadius(5)
                        
                        Button(action: {
                            loginWithFacebook()
                        }, label: {
                            HStack{
                                Image("facebook")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                Text("LOG IN WITH FACEBOOK")
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        })
                        .background(.blue)
                        .cornerRadius(5)
                        
                        Button(action: {
                            authManager.authState = .loggedIn
                        }, label: {
                            HStack{
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 10)
                                Text("LOG IN WITH APPLE")
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        })
                        .background(.gray.opacity(0.4))
                        .cornerRadius(5)
                    }
                }
                .frame(maxWidth: 300)
                
                
            }
            .onAppear() {
                location.startUpdatingLocation()
                
            }
        }
        .offset(x: isAnimating ? -UIScreen.main.bounds.width : 0)
        .animation(.easeInOut(duration: 0.3), value: isAnimating)
    }
    
    
    func loadQuoteView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
               withAnimation {
                   self.isLoading = false
               }
           }
       }
    
    func handleGoogleSignInButton() {
        
        guard let rootViewController = UIApplication.shared.rootViewController else {
            print("Could not find root view controller")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            guard let result = signInResult else {
                    // Inspect error
                    print("Error signing in: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
            print("Successfully signed in with Google")
            DispatchQueue.main.async {
                authManager.authState = .inProccess
            }
            
            let user = result.user
            let accessToken = user.accessToken.tokenString
            authManager.loginWithSocial(provider: "google", accessToken: accessToken, lat: location.location?.coordinate.latitude ?? 0, lon: location.location?.coordinate.longitude ?? 0) { result in
                    switch result {
                       case .success(let userInfo):
                           print("User Info:", userInfo)
                            DispatchQueue.main.async {
                                authManager.authState = .loggedIn
                            }
                       case .failure(let error):
                           print("Login failed:", error.localizedDescription)
                    }
                }
        }
    }
    
    func loginWithFacebook() {
            let loginManager = LoginManager()
            
            if let token = AccessToken.current, !token.isExpired {
                print("User already logged in. Access Token: \(token.tokenString)")
                fetchFacebookUserData()
            } else {
                loginManager.logIn(permissions: ["public_profile"], from: nil) { result, error in
                    if let error = error {
                        print("Login failed: \(error.localizedDescription)")
                    } else if let result = result, !result.isCancelled {
                        print("Login successful. Access Token: \(result.token?.tokenString ?? "No Token")")
                        fetchFacebookUserData()
                    } else {
                        print("Login was cancelled.")
                    }
                }
            }
        }
    
    func fetchFacebookUserData(){
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "user-id"]).start { (connection, result, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let userData = result as? [String: Any] {
                    if let userID = userData["id"] as? String {
                        authManager.loginWithSocial(provider: "facebook", accessToken: userID, lat: location.location?.coordinate.latitude ?? 0, lon: location.location?.coordinate.longitude ?? 0) { result in
                            switch result {
                               case .success(let userInfo):
                                   print("User Info:", userInfo)
                               case .failure(let error):
                                   print("Login failed:", error.localizedDescription)
                            }
                        }
                    }
                    
                }
            }
        } else {
            print("No active Facebook access token.")
        }
    }
}

#Preview {
    LoginView().environmentObject(AuthManager()).environmentObject(LocationDataManager())
}
