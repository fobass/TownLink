//
//  EventsDetailView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct EventsDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Hello, World!")
            }
            
            .navigationBarTitle("Nearest Couriers")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                //                leading:
                //                                    Text("Nearest Couriers")
                //                                    .font(.custom("TrebuchetMS-Bold", size: 22))
                //                                    .foregroundColor(Color.red.opacity(0.6))
                //                                    .shadow(color: Color.red.opacity(0.8), radius:  2)
                trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.custom("TrebuchetMS", size: 25))
                    })
                
            )
        }
    }
}

#Preview {
    EventsDetailView()
}
