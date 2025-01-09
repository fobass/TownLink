//
//  EventsView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI



struct EventsView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack{
            Button(action: {
                self.isPresented = true
            }) {
                ZStack{
                    Image("events")
                        .resizable()
                        .frame(height: 450, alignment: .center)
                        .cornerRadius(10)
                        .shadow(radius: 8)
                    
                    VStack(alignment: .center){
                        VStack(spacing: 20){
                            Text(EVENT_SECTION_TITLE)
                                .foregroundColor(Color.white)
                                .font(.custom("ArialRoundedMTBold", size: 25))
                            
                            Text(EVENT_SECTION_SUBTITLE)
                                .foregroundColor(Color.white.opacity(0.9))
                                .font(.custom("TrebuchetMS-Bold", size: 16))
                        }
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 20)
                        .padding([.top, .bottom], 30)
                        Spacer(minLength: 180)
                        
                        Button(action: {
                            //                            self.isPresented = true
                            //                                    self.selection = 2
                        }) {
                            Text("Exlpoer")
                                .padding([.top, .bottom], 10)
                                .padding([.leading, .trailing], 20)
                                .font(.custom("TrebuchetMS-Bold", size: 16))
                                .background(Color.white)
                                .cornerRadius(3)
                            
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding([.leading, .trailing, .bottom], 30)
        .padding([.top], 20)
        .fullScreenCover(isPresented: self.$isPresented) {
            EventsDetailView()
        }
    }
    
}

#Preview {
    EventsView()
}
