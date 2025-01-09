//
//  ContentView.swift
//  Alaget
//
//  Created by Ernist Isabekov on 13/07/2021.
//

import SwiftUI

struct Navbar: View {
    
    var body: some View {
        VStack{
            HStack{
                Text("TownLink")
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                    .foregroundColor(Color.red.opacity(0.6))
                    .shadow(color: Color.red.opacity(0.8), radius:  2)
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    withAnimation {
                        //                                    presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image(systemName: "person.circle")
                        .font(.custom("ArialRoundedMTBold", size: 22))
                        .foregroundColor(Color.red.opacity(0.6))
                        .background(Color.white)
                        .clipShape(Circle())
                })
                .padding(.trailing, 20)
                
                
                
            }
            .padding(.top, 55)
            .padding(.bottom, 5)
        }
        
    }
}


struct ContentView: View {
    @State var isPresented: Bool = false
    @State var selectedIndex: Int = 0
    @State var viewState = CGSize.zero
    @State var isViewPresented: Bool = false
    @State var isPresentedView: ViewPresented = .none

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        EventsView()
                        MarketView()
                        WorkersView()
                    }

                    Text("That's it for now")
                        .padding(.bottom, 80)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("TownLink")
                            .font(.custom("TrebuchetMS-Bold", size: 20))
                            .foregroundColor(Color.red.opacity(0.6))
                            .shadow(color: Color.red.opacity(0.8), radius: 2)
                            .padding(.leading, 20)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "person.circle")
                            .font(.custom("ArialRoundedMTBold", size: 22))
                            .foregroundColor(Color.red.opacity(0.6))
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
            }

            TabBar(index: $selectedIndex, isPresented: $isPresented)
        }
    }
}




struct TabBar: View {
    @Binding var index : Int
    @Binding var isPresented : Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
    
        HStack(spacing: 50){
            Spacer()
            Button(action: {
                self.isPresented = false
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
                self.isPresented = false
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
        .background{BlurView(style: colorSchemeInt()).ignoresSafeArea()}
        
    }
    
    func colorSchemeInt() -> UIBlurEffect.Style {
        return (colorScheme == .dark ? .dark : .light)
    }
    
}


#Preview {
    ContentView()
        .colorScheme(.dark)
}

enum ViewPresented {
    case none
    case courier
    case market
    case event
}
