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
                        handleSignInButton()
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
                        let loginManager = LoginManager()
                        if let token = AccessToken.current {
                            print("User already logged in. Access Token: \(token)")
                            self.fetchFacebookUserData()
                        } else {
                            loginManager.logIn(permissions: ["email", "public_profile", "user_birthday", "user_gender", "first_name", "last_name"], from: nil) { (result, error)  in
                                if let error = error {
                                    // Handle login error here
                                    print("Error: \(error.localizedDescription)")
                                } else if let result = result, !result.isCancelled {
                                    // Login successful, you can access the user's Facebook data here
                                    self.fetchFacebookUserData()
                                } else {
                                    // Login was canceled by the user
                                    print("Login was cancelled.")
                                }
                            }
                        }
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
                    
                    Button(action: {
                        authManager.authState = .loggedIn
                    }, label: {
                        HStack{
                           
                            Text("LOG IN WITH PTHONE NUMBER")
                                .padding(10)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                            
                        }
                    })
                    .background(.red.opacity(0.6))
                    .cornerRadius(5)
                    
                    
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
            print("Successfully signed in with Google")
            
            // Access the user profile
            let user = result.user
            let fullName = user.profile?.name ?? "No name"
            let email = user.profile?.email ?? "No email"
            let givenName = user.profile?.givenName ?? "No name"
            let familyName = user.profile?.familyName ?? "No name"
            let profileImageURL = user.profile?.imageURL(withDimension: 100) // Profile image URL (100x100 size)

            // Print user information
            print("Name: \(fullName)")
            print("Email: \(email)")
            if let imageURL = profileImageURL {
                print("Profile Image URL: \(imageURL)")
            }
        }
    }
    
    func fetchFacebookUserData(){
        if AccessToken.current != nil {
            // You can make a Graph API request here to fetch user data
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, birthday, gender, email"]).start { (connection, result, error) in
                if let error = error {
                    // Handle API request error here
                    print("Error: \(error.localizedDescription)")
                } else if let userData = result as? [String: Any] {
                    // Access the user data here
                    let userID = userData["id"] as? String
                    let name = userData["name"] as? String
                    let first_name = userData["first_name"] as? String
                    let birthday = userData["birthday"] as? String
                    let email = userData["email"] as? String

                    // Handle the user data as needed
                    print("User ID: \(userID ?? "")")
                    print("Name: \(name ?? "")")
                    
                }
            }
        } else {
            print("No active Facebook access token.")
        }
    }
}

#Preview {
    LoginView()
}
