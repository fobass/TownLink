//
//  MarketDetailView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI



struct MarketDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var item: Item
    @State private var opacity: Double = 0
    var body: some View {
        VStack {
            ZStack{
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
//                                withAnimation(Animation.linear.delay(2)) {
                                    self.presentationMode.wrappedValue.dismiss()
//                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.custom("ArialRoundedMTBold", size: 14))
                                    .padding(.all, 15)
                                    .foregroundColor(Color.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                          
                            .padding(.leading, 20)
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }, label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.custom("ArialRoundedMTBold", size: 14))
                                    .padding(.all, 15)
                                    .foregroundColor(Color.red)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                            
                            Button(action: {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }, label: {
                                Image(systemName: "heart")
                                    .font(.custom("ArialRoundedMTBold", size: 14))
                                    .padding(.all, 15)
                                    .foregroundColor(Color.red)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                            .padding(.trailing, 20)
                            
                            
                        }
                        .padding(.top, 30)
                        .zIndex(101)
                        Spacer()
                        
                        HStack{
                            Text("")
                            Spacer()
                        }
                        .frame(height: 100)
                        .background(Color.white)
                        .opacity(self.opacity)
                        .zIndex(99)
                    }
                    
                    Spacer()
                }
                .zIndex(100)
                
                ScrollView {
                    TabView {
                        Image("events")
                            .resizable()
//                        if let link = (item.imageLinks![0]) {
//                            VStack{
//                            WebImage(url: URL(string: link))
//                                .resizable()
                                //.aspectRatio(contentMode: self.zoomed ? .fill : .fit)
//                                .font(.title)
//                            }
//                            .onTapGesture {
//                                self.zoomed.toggle()
//                            }
//
//                        }
//                        if let link = (item.imageLinks![1]) {
//                            WebImage(url: URL(string: link))
//                                .resizable()
//                                .font(.title)
//                        }
//                        if let link = (item.imageLinks![2]) {
//                            WebImage(url: URL(string: link))
//                                .resizable()
//                                .font(.title)
//                        }
//                        if let link = (item.imageLinks![3]) {
//                            WebImage(url: URL(string: link))
//                                .resizable()
//                                .font(.title)
//                        }
                        
                        
                        //                        ForEach(item.imageLinks!, id:\.self) { link in
                        //                                WebImage(url: URL(string: link))
                        //                                    .resizable()
                        //                                    .font(.title)
                        //
                        //                                }
                    }
                    .frame(height: 500)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
//                    Spacer()
                    
                    GeometryReader { geometry in
                        Text("")
                            .onChange(of: (geometry.frame(in: .global).midY)) { value in
                                withAnimation {
                                    if (Double(value) < 490) {
                                        self.opacity = 1
                                    } else if (Double(value) > 502 ) {
                                        self.opacity = 0
                                    }
                                }
                            }
                    }
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("6 351 000 KGS")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(item.priceVal)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(item.description)
                                .font(.body)
                            
                            HStack {
                                Text("Показы: 27 093")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Image(systemName: "eye")
                                Text(String(item.views))
                                    .font(.caption)
                                
                                Image(systemName: "heart")
                                Text(String(item.liked))
                                    .font(.caption)
                            }
                            .foregroundColor(.gray)
                        }
                        .padding()
                        
                        // Action Buttons
                        HStack {
                            Button(action: {
                                // Call Action
                            }) {
                                Text("Позвонить")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                    .padding(15)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
                            
                            Button(action: {
                                // Message Action
                            }) {
                                Text("Написать")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(15)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.pink)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        
                        // Footer Section
                        VStack(alignment: .leading) {
                            Text("Количество комнат: 2 комнаты")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    // Action 1
                                }) {
                                    Text("Еще актуально?")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    // Action 2
                                }) {
                                    Text("Я заинтересован!")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            
                            HStack {
                                TextField("Напишите сообщение...", text: .constant(""))
                                    .padding(10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                
                                Button(action: {
                                    // Send Message
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
//                    self.store.getSeller(uuid: self.item.uuid)
                }
            }
            
            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
            
         
    }
}

#Preview {
    MarketDetailView(item: Item(user_id: 0, title: "Ttiiel", description: "Desc", price: 100, imagelink: "", lat: 0, lon: 0, dateadded: "", views: 5, sold: 0, liked: 4, distance: 4))
}



import SwiftUI

struct ItemDetailView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Top Image with Overlay
            ZStack(alignment: .bottom) {
                Image("events") // Replace with your image asset
                    .resizable()
                    .scaledToFit()
            }
            
            // Details Section
            VStack(alignment: .leading, spacing: 10) {
//                Text("6 351 000 KGS")
//                    .font(.title)
//                    .fontWeight(.bold)
                
                Text("73 000 USD")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("2 комнаты, 44 м², 104 серия, 3 этаж, Косметический ремонт")
                    .font(.body)
                
                HStack {
                    Text("Показы: 27 093")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "eye")
                    Text("461")
                        .font(.caption)
                    
                    Image(systemName: "heart")
                    Text("12")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            .padding()
            
            // Action Buttons
            HStack {
                Button(action: {
                    // Call Action
                }) {
                    Text("Позвонить")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 2)
                        )
                }
                
                Button(action: {
                    // Message Action
                }) {
                    Text("Написать")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            // Footer Section
            VStack(alignment: .leading) {
//                Text("Количество комнат: 2 комнаты")
//                    .font(.footnote)
//                    .foregroundColor(.gray)
                
                HStack(spacing: 10) {
                    Button(action: {
                        // Action 1
                    }) {
                        Text("Еще актуально?")
                            .font(.footnote)
                            .padding(8)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // Action 2
                    }) {
                        Text("Я заинтересован!")
                            .font(.footnote)
                            .padding(8)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                HStack {
                    TextField("Напишите сообщение...", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button(action: {
                        // Send Message
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.all))
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView()
    }
}



import SwiftUI

struct ImageSwipeView: View {
    let images = ["market", "events", "work", "image4"] // Your image names or URLs
    @State private var selectedImageIndex = 0
    @State private var isImageTapped = false
    
    var body: some View {
        VStack {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(self.images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .scaleEffect(isImageTapped ? 2 : 1) // Scale the image
                        .animation(.spring(), value: isImageTapped)
                        .onTapGesture {
                            // Toggle the scale when tapped
                            withAnimation {
                                isImageTapped.toggle()
                            }
                        }
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Enable swipe functionality
//            .frame(height: 300)  Set a fixed height for the TabView
            
            Spacer()
        }
    }
}

struct ContentView1: View {
    var body: some View {
        ImageSwipeView()
    }
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}

