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

func handleSignInButton() {
    
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
        
        // If sign in succeeded, display the app's main content view
        print("Successfully signed in with Google: ")
    }
}


struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isAnimating = false
    
    var body: some View {
        ZStack{
            Image("town_link_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(
                    Color.black.opacity(0.3) // Adds a semi-transparent dark overlay
                )
            VStack(){
                Spacer()
                Text("TownLink")
                    .font(.custom("TrebuchetMS-Bold", size: 36))
                    .foregroundColor(Color.white)
                Spacer()
                VStack(spacing: 10){
                    Button(action: {
//                        authManager.authState = .loggedIn
//                        handleSignInButton()
                    }, label: {
                        HStack{
                            Image(systemName: "g.circle.fill")
                            Text("LOG IN WITH GOOGLE")
                                .padding(10)
                                .frame(maxWidth: .infinity)
                        }
                    })
                    .background(.white)
                    .cornerRadius(5)
                    
                    Button(action: {
                        authManager.authState = .loggedIn
                    }, label: {
                        Text("LOG IN WITH FACEBOOK")
                            .padding(10)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    })
                    .background(.blue)
                    .cornerRadius(5)
                    
                    
                    Button(action: {
                        authManager.authState = .loggedIn
                    }, label: {
                        Text("LOG IN WITH PTHONE NUMBER")
                            .padding(10)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    })
                    .background(.red.opacity(0.6))
                    .cornerRadius(5)
//                    GoogleSignInButtonRepresentable()
//                        .frame(height: 50)
                    GoogleSignInButton(action: handleSignInButton)
                    Button(action: {
                        withAnimation {
                            isAnimating = true
                        }

                        // Simulate authentication delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            authManager.authState = .guest
                        }
                    }, label: {
                        Text("CONTINUE AS GUEST")
                            .padding(10)
                            .frame(maxWidth: .infinity)
                    })
                    .background(.black)
                    .cornerRadius(5)
                }
                .frame(maxWidth: 300)
            }
        }
        .offset(x: isAnimating ? -UIScreen.main.bounds.width : 0)
        .animation(.easeInOut(duration: 0.3), value: isAnimating)
    }
    
}

#Preview {
    LoginView()
}
