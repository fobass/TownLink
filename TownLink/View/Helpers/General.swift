//
//  General.swift
//  TownLink
//
//  Created by Ernist Isabekov on 3/10/25.
//

import Foundation
import SwiftUI

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

// MARK: Get Safe Area size for padding from top
extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
    // Now it time to ScrollView Offset Effect
    func offset(offset: Binding<CGFloat>) -> some View {
        return self
            .overlay {
                GeometryReader {
                    let minY = $0.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self, perform: { value in
                    offset.wrappedValue = value
                })
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct Global {
    static var tabBar : UITabBar?
}


extension UITabBar {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        Global.tabBar = self
        print("Tab Bar moved to superview")
    }
}


struct Screen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TabBar1: View {
    @Binding var index : Int
    @Binding var isPresented : Bool
    @State private var isAddContentPresentedView = false
    @State private var settingsDetent = PresentationDetent.medium
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
                isAddContentPresentedView.toggle()
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
//                    withAnimation {
                        //                                    presentationMode.wrappedValue.dismiss()
//                    }
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


var dummyText = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat"











//
//  EventsView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI


import SwiftUI

struct CoffeeShopView: View {
    let coffeeImages = ["k-1", "k-2", "k-3", "k-4", "k-5"]
    @State private var selectedImage = "k-1"
    @State private var isFullScreen = false
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // First cafe image
                Image(selectedImage)
                       .resizable()
                       .scaledToFit()
                       .frame(height: 400) // Ensuring a consistent size
                       .cornerRadius(12)
                       .padding(.horizontal)
                       .transition(.opacity.combined(with: .scale)) // Smooth transition
                       .animation(.easeInOut(duration: 0.3), value: selectedImage)
                       .onTapGesture {
                           isFullScreen = true
                       }
                       .fullScreenCover(isPresented: $isFullScreen) {
                           ZStack {
                               Color.black.ignoresSafeArea()
                               Image(selectedImage)
                                   .resizable()
                                   .scaledToFit()
                                   .onTapGesture {
                                       isFullScreen = false
                                   }
                           }
                       }
                
                // Horizontal scroll view for coffee images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(coffeeImages, id: \..self) { image in
                            Image(image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    withAnimation {
                                            selectedImage = image
                                        }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
    }
}

struct CoffeeShopView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeShopView()
    }
}


