//
//  ContentView.swift
//  Alaget
//
//  Created by Ernist Isabekov on 13/07/2021.
//

import SwiftUI


struct AddContentView: View {
    @State private var addPresentedView: AddPresentedView? = nil
    @State private var isViewPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var eventStore: EventStore
    @EnvironmentObject var imageStore : ImageUploaderStore
    var body: some View {
        VStack {
            HStack {
                Text("Create New Listing")
                    .font(.custom("TrebuchetMS-Bold", size: 22))
                    .foregroundColor(Color.gray.opacity(0.8))
                Spacer()
            }
            .padding([.bottom, .top], 0)
//            Spacer()
            Button(action: {
                addPresentedView = .event
                isViewPresented = true
            }, label: {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("EVENT")
                            .font(.custom("TrebuchetMS-Bold", size: 22))
                            .foregroundColor(Color.white)
                        Text("Add your new event here.")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    Spacer()
                    Image("events")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .padding(10)
                }
                .background(Color.blue.opacity(0.8))
                .cornerRadius(10)
            })

            Button(action: {
                addPresentedView = .market
                isViewPresented = true
            }, label: {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ITEM")
                            .font(.custom("TrebuchetMS-Bold", size: 22))
                            .foregroundColor(Color.white)
                        Text("Have something to sell?")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    Spacer()
                    Image("market")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .padding(10)
                }
                .background(Color.orange.opacity(0.8))
                .cornerRadius(10)
            })

            Button(action: {
                addPresentedView = .work
                isViewPresented = true
            }, label: {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("WORK")
                            .font(.custom("TrebuchetMS-Bold", size: 22))
                            .foregroundColor(Color.white)
                        Text("Add your new event here")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    Spacer()
                    Image("workers")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .padding(10)
                }
                .background(Color.red.opacity(0.8))
                .cornerRadius(10)
            })

//                Spacer()
        }
        .padding([.leading, .trailing], 20)

        .sheet(item: $addPresentedView, onDismiss: {
            print("Dismissed fullScreenCover")
//            presentationMode.wrappedValue.dismiss()
        }) { view in
            switch view {
                case .defaultView:
                    Text("def")
                case .event:
                    Add_Event_View().environmentObject(eventStore).environmentObject(imageStore)
                case .market:
                    AddListingView()
                case .work:
                    Text("Work")
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: Int = 0
    @State var isPresented: Bool = false
    @StateObject var eventStore: EventStore
    @StateObject var locationManager = LocationDataManager()
    @StateObject var profileStore: ProfileStore
    @StateObject var imageStore : ImageUploaderStore
    init() {
        let locationManager = LocationDataManager()
        _locationManager = StateObject(wrappedValue: locationManager)
        _eventStore = StateObject(wrappedValue: EventStore(locationManager: locationManager))
        UITabBar.appearance().isHidden = true
        _imageStore = StateObject(wrappedValue: ImageUploaderStore())
        _profileStore = StateObject(wrappedValue: ProfileStore())
        profileStore.getById(with: -1)
    }
    @State private var isTabBarHidden = false
    @State private var isScrolledToBottom: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if locationManager.isLocationReady {
                    TabView(selection: $selectedTab) {
                        EventsView(isTabBarHidden: $isTabBarHidden, isScrolledToBottom: $isScrolledToBottom)
                            .environmentObject(eventStore)
                            .environmentObject(profileStore)
                            .tag(0)
                        MessagesView()
                            .tag(1)
                    }
                    .safeAreaInset(edge: .bottom) {
                        if (!isTabBarHidden) {
                            TabBar(index: $selectedTab, isPresented: $isPresented).environmentObject(eventStore).environmentObject(imageStore)
                                .background(
                                    ZStack {
                                        if (isScrolledToBottom) {
                                            customBackgroundColor
                                        } else {
                                            VStack{
                                                Spacer()
                                                HStack{
                                                    Spacer()
                                                    Text("")
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .background(Material.ultraThin)
                                        }
                                    }
                                )
                                .overlay(
                                       Rectangle()
                                           .frame(height: 1) // Border thickness
                                        .foregroundColor(isScrolledToBottom ? customBackgroundColor : .gray.opacity(0.1)),
                                       alignment: .top
                                   )
                        }
                    }
                    
                } else {
                    ProgressView("Fetching Location...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .onAppear {
                            locationManager.startUpdatingLocation()
                        }
                }
                
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                
            }, content: {
                Add_Event_View().environmentObject(eventStore).environmentObject(imageStore)
            })
        }
    }
    
    func colorSchemeInt() -> UIBlurEffect.Style {
        return (colorScheme == .dark ? .dark : .light)
    }
    
    var customBackgroundColor: Color {
            colorScheme == .dark ? Color.black : Color.white // Custom logic
    }
   
}

struct TabBar: View {
    @Binding var index : Int
    @Binding var isPresented : Bool
    @State private var isAddContentPresentedView = false
    @State private var settingsDetent = PresentationDetent.medium
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
    
        HStack(spacing: 50){
            Spacer()
            Button(action: {
//                self.isPresented = false
                self.index = 0
            }, label: {
                VStack(alignment: .center, spacing: 5){
                    Image(systemName: (self.index == 0) ? "house.fill" : "house")
                        .imageScale(.large)
                        .font(.system(size: 20))
                }
                .cornerRadius(10)
            })
            
            
            Button(action: {
                self.isPresented.toggle()
//                isAddContentPresentedView.toggle()
//                self.index = 3
            }, label: {
                VStack{
                    Image(systemName: "plus")
                        .padding()
                        .imageScale(.large)
                        .frame(width: 100, height: 50)
                        .background(LINEAR_GRADIENT)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                        .font(.title2)
                }
            })
            .padding(.top, 5)
            
            Button(action: {
//                self.isPresented = false
                self.index = 1
            }, label: {
                VStack(alignment: .center, spacing: 5){
                    Image(systemName: (self.index == 1) ? "envelope.fill" : "envelope")
                        .imageScale(.large)
                        .font(.system(size: 22))
                }
                .cornerRadius(10)
            })
            Spacer()
        }
        
        .sheet(isPresented: $isAddContentPresentedView, onDismiss: {
            
        }, content: {
            AddContentView()
                .presentationDetents([.medium])
        })
        
    }
    
    
    
    func colorSchemeInt() -> UIBlurEffect.Style {
        return (colorScheme == .dark ? .dark : .light)
    }
    
}


#Preview {
    ContentView()
        .environmentObject(AuthManager())
        .environmentObject(ProfileStore())
        .environmentObject(EventStore(locationManager: LocationDataManager()))
//    ContentView().environmentObject(EventStore(locationManager: LocationDataManager()))
//    AddContentView()
//        .colorScheme(.dark)
}
