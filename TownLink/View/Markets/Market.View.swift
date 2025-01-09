//
//  MarketView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct MarketHeaderView: View {
    var body: some View{
        VStack{
            Divider()
                .background(Color.blue.opacity(0.3))
            VStack(alignment: .leading){
                HStack{
                    Text(MARKET_SECTION_TITLE)
                        .foregroundColor(titleFontColor())
                        .font(.custom("TrebuchetMS-Bold", size: 24))
                        .padding(.bottom, 10)
                    Spacer()
                }
                Text(MARKET_SECTION_SUBTITLE)
//                    .foregroundColor(Color.white.opacity(0.9))
                    .font(.custom("TrebuchetMS", size: 16))
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding([.leading, .trailing], 30)
        }
    }
        
    func titleFontColor() -> Color {
        return Color.blue.opacity(0.8)
    }
}


struct MarketView: View {
    @ObservedObject var store = MarketStore()
    private let rows = [GridItem(.fixed(160))]
    @State var isPresented: Bool = false
    var body: some View {
        VStack{
            MarketHeaderView()
            if (store.items.count == 0) {
                VStack{
                    Image("market")
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
                                NavigationLink(destination: MarketDetailView(item: item)) {
//                                        Button(action: {
//                                            self.isPresented = true
//                                        }) {
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text(item.DisplayDistance)
                                                        .foregroundColor(Color.blue.opacity(0.6))
                                                        .font(.custom("TrebuchetMS-Bold", size: 14))
                                                        .padding(.all, 5)
                                                }
                                                Spacer()
                                                HStack{
                                                    Text(item.title)
                                                    Spacer()
                                                    Text(item.priceVal)
                                                        .foregroundColor(Color.red.opacity(0.8))
                                                    
                                                }
                                                .font(.custom("TrebuchetMS", size: 16))
                                                .padding(.all, 5)
    //                                            .background(Color.white)
                                                
                                            }
                                            .frame(width: 200,height: .infinity)
                                            .background(Color.green.opacity(0.5))
                                            
//                                        }
                                        
                                    }
                            }
                        }
                        .padding([.leading, .trailing], 30)
                        
                    }
                    
                    VStack{
                        HStack {
//                            NavigationLink(destination: MarketListView()) {
                            Button(action: {
                                self.isPresented = true
                            }) {
                                Text("Explore all")
                                    .padding(.all, 10)
                                    .font(.custom("TrebuchetMS-Bold", size: 16))
                                    .foregroundColor(Color.blue.opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                //                            }
                            }
                            Spacer()
                        }
                        
                        .padding(.top, 20)
                        .padding([.leading, .trailing, .bottom], 30)
                    }
                }
            }

        }
        .fullScreenCover(isPresented: self.$isPresented) {
            MarketListView()
        }
      
//
    }
}

#Preview {
    MarketView()
}
