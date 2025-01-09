//
//  Market.List.View.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/27/24.
//

import SwiftUI

struct WaterfallGridItem: View {
    let item: Item
    
    var body: some View {
        VStack{
            ZStack{
                Image("events")
                    .resizable()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "heart")
                                .font(.custom("TrebuchetMS", size: 16))
                                .foregroundColor(.white)
                        })
                        .padding(5)
                    }
                }
            }
            HStack{
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(Font.system(size: 12))
                    Text(item.priceVal)
                        .font(Font.system(size: 12))
                        .bold()
                        .foregroundColor(.green)
                    
                }
                Spacer()
                VStack{
                    Spacer()
                    Text(item.DisplayDistance)
                        .font(Font.system(size: 12))
                        .foregroundColor(.black)
                }
                
            }
            .padding([.trailing, .leading, .bottom], 5)
        }
        .background(Color.green.opacity(0.1))
        .cornerRadius(5)
    }
}

struct MarketListView: View {
    @ObservedObject var store = MarketStore()
    @State var searchVal : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    HStack{
                        Button(action: {
//                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        })
//                        .padding([.trailing, .leading], 20)
//                        .padding([.top, .bottom], 5)
                        .padding(3)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(5)
                        
                        Button(action: {}) {
                            Text("Free")
                                .font(Font.system(size: 12))
                        }
                        .padding([.trailing, .leading], 20)
                        .padding([.top, .bottom], 5)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(5)
                        Spacer()
                        
                    }
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 5),
                            GridItem(.flexible(), spacing: 5)
                        ],
                        spacing: 5
                    ) {
                        ForEach(filteredItems, id: \.self) { item in
                            NavigationLink(destination: MarketDetailView(item: item)) {
                                WaterfallGridItem(item: item)
                            }
                        }
                    }
                    .searchable(text: $searchVal)
                
                }
                .padding([.trailing, .leading])
            }
            .navigationBarItems(
                leading:
                        Text("Nearest Items")
                        .font(.custom("TrebuchetMS-Bold", size: 20))
                        .foregroundColor(Color.green.opacity(0.6))
                        .shadow(color: Color.green.opacity(0.5), radius:  2),
                trailing:
                    HStack{
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark.circle")
                        })
                    }
//                    .padding(.horizontal, -10)
                
            )
        }
    }
    
    
    var filteredItems : [Item] {
        if searchVal.isEmpty {
            return store.items
        }
        
        return store.items.filter({$0.title.localizedCaseInsensitiveContains(searchVal)})
    }
    
}

#Preview {
    MarketListView()
}
