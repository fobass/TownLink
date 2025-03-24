//
//  TownLinkApp.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/9/25.
//

import SwiftUI
import GoogleSignIn
import FacebookCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}


@main
struct TownLinkApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject var locationManager = LocationDataManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isLoading = true
    @State private var isAnimating = false
    @State private var progress: Double = 0
    @State private var timer: Timer?
//    init() {
//        authManager.checkAuthentication()
//    }
    var body: some Scene {
        WindowGroup {
//            ContentView().environmentObject(EventStore(locationManager: LocationDataManager()))
            if isLoading {
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
                        Text("Your Local Connection Hub")
                            .font(.custom("TrebuchetMS", size: 16))
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("")
                        Spacer()
                        ProgressView(value: progress, total: 100)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(maxWidth: 300)
                        
//                        Spacer()
                        
                    }
                    .offset(x: isAnimating ? -UIScreen.main.bounds.width : 0)
                    .animation(.easeInOut(duration: 0.3), value: isAnimating)
                    .onAppear {
//                        authManager.logoutUser()
                        authManager.checkAuthentication()
                        startLoading()
                    }
                    .onDisappear() {
                        
                        timer?.invalidate()
                    }
                }
            } else {
                if (authManager.authState == .unauthenticated) {
                    LoginView().environmentObject(authManager).environmentObject(locationManager)
                        
                } else if (authManager.authState == .loggedIn){
                    ContentView().environmentObject(authManager).environmentObject(EventStore(locationManager: LocationDataManager()))
                        .onAppear {
                            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                                // Check if `user` exists; otherwise, do something with `error`
                            }
                        }
                }
            }
        }

    }
    
    func startLoading() {
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
           if progress < 100 {
               progress += 2 // Small increments for a smooth transition
           } else {
               timer.invalidate()
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                   withAnimation {
                       isLoading = false
                   }
               }
           }
       }
    }
}
