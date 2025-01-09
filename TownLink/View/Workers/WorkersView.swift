//
//  WorkersView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct WorkersHeaderView: View {
    var body: some View{
        VStack{
            Divider()
                .background(Color.blue.opacity(0.3))
            VStack(alignment: .leading){
                HStack{
                    Text(WORKER_SECTION_TITLE)
                        .foregroundColor(titleFontColor())
                        .font(.custom("TrebuchetMS-Bold", size: 24))
                        .padding(.bottom, 10)
                    Spacer()
                }
                Text(WORKER_SECTION_SUBTITLE)
//                    .foregroundColor(Color.white.opacity(0.9))
                    .font(.custom("TrebuchetMS", size: 16))
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding([.leading, .trailing], 30)
        }
    }
    
    func titleFontColor() -> Color {
        return Color.green.opacity(0.8)
    }
}

struct WorkersView: View {
    @ObservedObject var store = WorkerStore()
    private let rows = [GridItem(.fixed(160))]
    var body: some View {
        VStack{
            WorkersHeaderView()
            
            if (store.items.count == 0) {
                VStack{
                    Image("workers")
                        .resizable()
                        .frame(height: 270)
                        .cornerRadius(10)
                }
                .padding([.leading, .trailing, .bottom], 30)
                .padding([.top], 20)
            } else {
                VStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 20) {
                            
                            ForEach(self.store.items.prefix(3), id: \.self) { item in
                                NavigationLink(destination: WorkerDetailView()) {
                                    HStack{
                                        Text(item.name)
                                    }
                                    .frame(width: 250, height: 150)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(16)
                                    .shadow(radius: 4)
                                }
                            }
                        }
                        .frame(height: 210)
                        .padding([.leading, .trailing], 30)
                        
                    }
                    
                    VStack{
                        HStack {
                            NavigationLink(destination: WorkerDetailView()) {
                                Text("Explore all")
                                    .padding(.all, 10)
                                    .font(.custom("TrebuchetMS-Bold", size: 16))
                                    .foregroundColor(Color.green.opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            Spacer()
                        }
                        
                        .padding(.top, 20)
                        .padding([.leading, .trailing, .bottom], 30)
                    }
                }
            }
            
            
            
        }
    }
 
}

#Preview {
    WorkersView()
}
