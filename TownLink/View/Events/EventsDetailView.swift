//
//  EventsDetailView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct EventsDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: EventStore
    var event_id: Int = 0
    @State private var opacity: Double = 0
    @State private var mapViewPresented: Bool = false
    @State var selectedTab: String = "ABOUT"
    let images = ["events", "workers", "market"]
    var body: some View {
        VStack {
            ZStack{
                VStack{
                    ZStack{
                        HStack{
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .font(.custom("ArialRoundedMTBold", size: 24))
                                    .padding(.all, 15)
                                    .foregroundColor(opacity == 0.0 ? Color.white : Color.black)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                            })
                            .padding(.leading, 20)
                            Spacer()
                          
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
                    VStack{
                        ImageCarouselScrollView()
                    }
                    .frame(height: 500)
                       
                
                    
                    GeometryReader { geometry in
                        Text("")
                            .onChange(of: (geometry.frame(in: .global).midY)) { oldValue, newValue in
                                withAnimation {
                                    if (Double(newValue) < 490) {
                                        self.opacity = 1
                                    } else if (Double(newValue) > 502 ) {
                                        self.opacity = 0
                                    }
                                }
                            }
                    }
                    VStack{
                        VStack{
                            HStack{
                                Text("\(store.event_detail.name)")
                                    .fontWeight(.bold)
                                    .font(.system(size: 42))
                                    .padding(.top, -20)
                                Spacer()
                            }
                            
                            HStack{
                                Text("\(store.event_detail.starttime.uppercased())")
                                Spacer()
                            }
                        }
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 10) {
                                Button(action: {
                                    selectedTab = "ABOUT"
                                }) {
                                    Text("ABOUT")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(selectedTab == "ABOUT" ? Color.green.opacity(0.5) : Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    selectedTab = "ATTENDEES"
                                }) {
                                    Text("ATTENDEES")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(selectedTab == "ATTENDEES" ? Color.green.opacity(0.5) : Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    mapViewPresented.toggle()
                                }) {
                                    Text("LOCATION")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                Spacer()
                            }
                            
                            Spacer()
                            
                        }
                        if selectedTab == "ABOUT" {
                            VStack{
                                HStack{
                                    Text("\(store.event_detail.description)")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                        } else if selectedTab == "ATTENDEES" {
                            VStack{
                                HStack{
                                    Text("users ")
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding([.trailing, .leading], 10)
                    .padding(.top, -20)
                }
                
                .onAppear {
                    self.store.getEventById(event_id: self.event_id)
                }
                
                .sheet(isPresented: $mapViewPresented, content: {
                    EventMapView(latitude: store.event_detail.latitude, longitude: store.event_detail.latitude, name: store.event_detail.name)
                })
                
                Spacer()
                VStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            self.setAttend()
                        }) {
                            Text("Buy")
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
                            Text("Share")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(Color.pink)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 5)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
            
         
    }
    
    func setAttend(){
        let newAttend = Attend.init(attendee_id: -1, user_id: 1, event_id: self.event_id, status: "", ticket_qr_code: "", created_at: Date())
        store.setAttend(newAttend: newAttend) { success in
            if success {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}


struct ImageCarouselScrollView: View {
    let images = ["events", "workers", "market"]
    
    var body: some View {
        ZStack{
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.red
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
            }
            
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.002), Color.black]),
                        startPoint: .bottom,
                        endPoint: .center
                    ))
            
        }
        .frame(height: 500)
    }
    

}

#Preview {
    EventsDetailView().environmentObject(EventStore(locationManager: LocationDataManager()))
//    EventMapView()
//    ImageCarouselScrollView()
}


import MapKit


struct EventMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var name: String = ""
    
    @State private var region: MKCoordinateRegion
    @Environment(\.presentationMode) var presentationMode

    init(latitude: Double, longitude: Double, name: String) {
            _latitude = State(initialValue: latitude)
            _longitude = State(initialValue: longitude)
            _name = State(initialValue: name)
            
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    
    var body: some View {
        ZStack {
//            VStack {
//                ZStack {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            self.presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            Image(systemName: "xmark")
//                                .font(.custom("ArialRoundedMTBold", size: 24))
//                                .padding(.all, 15)
//                                .foregroundColor(Color.black)
//                                .background(Color.white.opacity(0.3))
//                                .clipShape(Rectangle())
//                                .cornerRadius(10)
//                        })
//                        .padding(.trailing, 20)
//                    }
//                    .zIndex(101)
//                    Spacer()
//                    
//                    HStack {
//                        Text("")
//                        Spacer()
//                    }
//                    .frame(height: 100)
//                    .background(Color.white)
//                    .opacity(0.0)
//                    .zIndex(99)
//                }
//                
//                Spacer()
//            }
//            .zIndex(100)
            
            Map(position: .constant(.region(region))) {
                Annotation(name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
            .edgesIgnoringSafeArea(.all)
//            .overlay(
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        
//                        // Zoom In Button
//                        Button(action: {
//                            zoomIn()
//                        }) {
//                            Image(systemName: "plus.magnifyingglass")
//                                .font(.title)
//                                .padding()
//                                .background(Color.white.opacity(0.7))
//                                .clipShape(Circle())
//                        }
//                        .padding(.trailing, 15)
//
//                        // Zoom Out Button
//                        Button(action: {
//                            zoomOut()
//                        }) {
//                            Image(systemName: "minus.magnifyingglass")
//                                .font(.title)
//                                .padding()
//                                .background(Color.white.opacity(0.7))
//                                .clipShape(Circle())
//                        }
//                        .padding(.trailing, 15)
//                    }
//                    .padding(.bottom, 50)
//                }
//            )
        }
    }
    
    // Zoom In Function
    func zoomIn() {
        let newSpan = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 0.5, longitudeDelta: region.span.longitudeDelta * 0.5)
        region.span = newSpan
    }

    // Zoom Out Function
    func zoomOut() {
        let newSpan = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 2, longitudeDelta: region.span.longitudeDelta * 2)
        region.span = newSpan
    }
}

