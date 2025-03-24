//
//  EventsView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI

struct Photo: Identifiable {
    var id = UUID()
    var name: String
    var subart: [Photo]
}

// Create sample photos with subart
let samplePhotos = (1...5).map { index in
    Photo(
        name: "k-\(index)",
        subart: (1...5).map { subIndex in
            Photo(name: "k-\(index)-\(subIndex)", subart: [])
        }
    )
}

struct EventsView: View {
    @Binding var isTabBarHidden: Bool
    @Binding var isScrolledToBottom: Bool
    @State var showDetailPage: Bool = false
    @State var currentItem: Event?
    
    @Namespace var animation
    
    @State var isAnimationView: Bool = false
    @State var animationContent: Bool = false
    @State var scale : CGFloat = 1
    @State var scrollOffset : CGFloat  = 0
    @State var selectedImage = "events"
    let coffeeImages = ["events", "k-1", "k-2", "k-3", "k-4", "k-5"]
    @State private var isImageFullScreen = false
    @State var gridLayout: [GridItem] = [ GridItem() ]
    @State var isPopupProfileView: Bool = false
    @State var isDetailScrollOnTop: Bool = true
    @EnvironmentObject var store: EventStore
    @EnvironmentObject var profileStore: ProfileStore
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30, content: {
                HStack(alignment: .top, content: {
                    VStack(alignment: .leading, spacing: 3, content: {
                        Text("Today")
                            .font(.title.bold())
                        
                        Text(getCurrentTime())
                            .font(.callout.bold())
                            .opacity(0.8)
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 10){
                        Button(action: {
                            isPopupProfileView = true
                            //
                        }, label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                        })
                        Button(action: {
                            isPopupProfileView = true
                            //
                        }, label: {
                            Image("town_link_bg")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        })
                    }
                    
                })
                .sheet(isPresented: $isPopupProfileView, content: {
                    ProfileView(profile: profileStore.profile).environmentObject(profileStore).environmentObject(AuthManager())
                })
                .padding(.horizontal)
                .opacity(isAnimationView ? 0 : 1)
            })
//            .background(
//                GeometryReader { proxy -> Color in
//                    let offset = proxy.frame(in: .global).minY
//                    DispatchQueue.main.async {
//                        if (offset >= 0) {
//                            print("Scrolled to top \(offset)")
//                        }
//                    }
//                    return Color.clear
//                }
//            )
            VStack{
                ForEach(store.events, id: \.event_id) { item in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            currentItem = item
                            showDetailPage = true
                        }
                    } label: {
                        VStack{
                            CardView(item: item)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.white)
                                .scaleEffect(currentItem?.event_id == item.event_id && showDetailPage ? 1 : 0.9)
                            //                            .padding(.horizontal, 25)
                            //                            .padding(.vertical, 15)
                                .scaleEffect(scale)
                        }
//                        .background(.red)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ? (currentItem?.event_id == item.event_id ? 1 : 0) : 1)
                    //                    .padding(.bottom, item.event_id == store.events.last?.event_id ? 50 : 0)
                }
                
            }
            .background(
                GeometryReader { proxy -> Color in
                    let offset = proxy.frame(in: .global).maxY
                    isScrolledToBottom = offset < 800
                    return Color.clear
                }
            )
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .safeAreaInset(edge: .bottom, spacing: 10) {
            Text("")
              .padding(.top, 27)
        }
        
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            if (value >= 0)  {
                print("scrool at top ")
            }
        }
        .overlay {
            if let currentItem = currentItem, showDetailPage {
                DetailView(item: currentItem)
                    .edgesIgnoringSafeArea(.top)
            }
        }
        .onAppear {
            store.fetchEvents(radius: 10000000, category: "music", sortBy: "distance")
        }
//        .background(Color.primary)
        
    }
    
    // MARK: Card View Holder
    @ViewBuilder
    func CardView(item: Event) -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            ZStack(alignment: .topLeading, content: {
                GeometryReader { proxy in
                    let size = proxy.size
                        Image(!isAnimationView ? "events" : selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipped()
//                            .onTapGesture {
//                                print("isAnimationView:", isAnimationView)
//                                  if !isAnimationView {
//                                      isImageFullScreen = true
//                                  }
//                            }
//                            .allowsHitTesting(true)
//                            .fullScreenCover(isPresented: $isImageFullScreen) {
//                                ZStack {
//                                    Color.black.ignoresSafeArea()
//                                    Image(selectedImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .onTapGesture {
//                                            isImageFullScreen = false
//                                        }
//                                }
//                            }
                            
                            
//                                                if !isAnimationView {
//                        LinearGradient(
//                            colors: [Color.clear, item.color(id: item.event_id).opacity(1.2)],
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
                        //                            .allowsHitTesting(false) // Allow taps to pass through the gradient
//                                                }
                        
                        VStack(alignment: .leading, content: {
                            Spacer()
                            Text("\(item.name)")
                                .font(.callout.bold())
                            
                            Text("\(item.starttime)")
                                .font(.title.bold())
                            
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.white)
//                    .background(
//                        !isAnimationView ?
//                            AnyView(
//                                LinearGradient(
//                                    colors: [Color.clear, item.color(id: item.event_id).opacity(0.5)],
//                                    startPoint: .topTrailing,
//                                    endPoint: .bottom
//                                )
//                            )
//                            : AnyView(Color(.systemBackground))
//                    )
                    
                    
                }
                .frame(height: 340)
                .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
            })
            VStack{
                
                HStack(spacing: 12, content: {
                    Image("events")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(.rect(cornerRadius: 15))
                    
                    VStack(alignment: .leading, spacing: 0, content: {
                        Text("\(item.town_name)")
                            .font(.caption.bold())
                        
                        Text("\(item.starttime)")
                            .font(.subheadline.bold())
                        //
                        //                    Text("\(item.appDescription)")
                        //                        .font(.caption.bold())
                    })
                    
                    Spacer()
                    
                    Button {
                        if !isAnimationView {
                            isImageFullScreen = true
                        }
                    } label: {
                        Text("Attend")
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background {
                                Capsule().fill(.ultraThinMaterial)
                            }
                    }
                })
                .padding()
//                .background(item.color(id: item.event_id))
                .background(isAnimationView ? item.color(id: item.event_id).opacity(0.5) : item.color(id: item.event_id).opacity(0.7))
               
                
            }
            .clipShape(.rect(bottomLeadingRadius: isAnimationView ? 0 : 20, bottomTrailingRadius:  isAnimationView ? 0 : 20))
            
        })
        
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(item.color(id: item.event_id).opacity(0.2), lineWidth: isAnimationView ? 0 : 0.8)
        )
        .matchedGeometryEffect(id: item.event_id, in: animation)
        
   }
    
    // MARK: Detials PAge
    func DetailView(item: Event) -> some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                GeometryReader { proxy -> Color in
                      let offset = proxy.frame(in: .global).minY
//                      print("Scroll offset \(offset)")
                      isDetailScrollOnTop = (offset >= 520)
                      
                      return Color.clear
                  }
                  .frame(height: 0)
                VStack {
                    VStack{
                        CardView(item: item)
                            .scaleEffect(isAnimationView ? 1 : 0.90)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ value in
                                        onChange(value: value)
                                    })
                                    .onEnded({ value in
                                        onEnd(value: value)
                                    })
                            )
                    }
                    VStack{
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(coffeeImages, id: \..self) { image in
                                    VStack{
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
                                    
                                    .opacity((selectedImage == image) ? 0.3 : 1)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        
                        VStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("About")
                                        .font(.callout.bold())
                                        .opacity(0.8)
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                Text(store.event_detail.name + ". " + store.event_detail.description)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(8)
                                    .padding(.bottom, 20)
                                
                                Divider()
                                VStack{
                                    HStack{
                                        Text("Attendees")
                                            .font(.callout.bold())
                                            .opacity(0.8)
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    HStack{
                                        ForEach(store.event_attendees, id: \.profile_id) { atten in
                                            AsyncImage(url: URL(string: atten.photo_url)) { phase in
                                                
                                                switch phase {
                                                case .success(let image):
                                                    image.resizable()  // Apply modifiers on `image`
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 25, height: 25)
                                                        .clipShape(.rect(cornerRadius: 50))
                                                case .failure:
                                                    Image(systemName: "photo") // Placeholder when loading fails
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 25, height: 25)
                                                        .clipShape(.rect(cornerRadius: 50))
                                                case .empty:
                                                    ProgressView() // Show loading indicator
                                                        .frame(width: 25, height: 25)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
//                                        Image("events")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fill)
//                                            .frame(width: 25, height: 25)
//                                            .clipShape(.rect(cornerRadius: 50))
                                        Spacer()
                                        
                                        Text("Max. \(String(store.event_detail.max_attendees))")
                                            .font(.footnote)
                                    }
                                }
                                .padding(.bottom, 20)
                                
                                
                                
                                Divider()
                                EventMapView(latitude: store.event_detail.latitude, longitude: store.event_detail.latitude, name: store.event_detail.name)
                                    .frame(height: 250)
                                    .padding(.vertical, 10)
                            }
                            
                            Divider()
                            
                            Button {
                                
                            } label: {
                                Label {
                                    Text("Share Event")
                                } icon: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .foregroundColor(.primary)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 25)
                                .background {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                }
                            }
                        }
                        .padding()
                    }
                    .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                    .opacity(animationContent ? 1 : 0)
                    .scaleEffect(isAnimationView ? 1 : 0, anchor: .top)
                    
                }
                .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
                .offset(offset: $scrollOffset)
                
            }
            .coordinateSpace(name: "SCROLL")
            
            
                VStack {
                    if (self.scale) != 0{
                    HStack {
                        Spacer()
                        Button {
                            closeDetailView()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        .padding([.top], safeArea().top)
                        .padding(.trailing)
                        .opacity(isAnimationView ? 1 : 0)
                    }
                    Spacer()
                }
                
            }.padding(.vertical, -30)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(item.color(id: item.event_id).opacity(0.2), lineWidth:  (1 - scale) > 0 ? 0.8 : 0)
        )
//        .overlay(alignment: .topTrailing, content: {
//            Button {
//                // Close View
//                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
//                    isAnimationView = false
//                    animationContent = false
//                }
//                
//                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
//                    currentItem = nil
//                    showDetailPage = false
//                }
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title)
//                    .foregroundStyle(.white)
//            }
//            .padding([.top], safeArea().top)
//            .padding(.trailing)
//            .opacity(isAnimationView ? 1 : 0)
//        })
        .scaleEffect(scale)
        .onAppear() {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                isAnimationView = true
            }
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                animationContent = true
            }
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                isTabBarHidden = true
//                if (Global.tabBar != nil) {
//                    Global.tabBar!.isHidden = true
//                }
            }
            
            store.getEventById(event_id: item.event_id)
            store.getEventAttendees(with: item.event_id)
        }
        .onDisappear() {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                isTabBarHidden = false
//                if (Global.tabBar != nil) {
//                    Global.tabBar!.isHidden = false
//                }
            }
        }
        
        .transition(.identity)
    }
    
    private func onChange(value: DragGesture.Value) {
        if (isDetailScrollOnTop) {
            let scale = value.translation.height / Screen.height
            if (1 - scale) > 0.7 {
                self.scale = 1 - scale
            }
        }
        
//        if (self.scale < 0.9) {
//            closeDetailView()
//            self.scale = 1
//        }
    }
    private func onEnd(value: DragGesture.Value) {
        withAnimation(.spring()) {
            if (self.scale < 0.9) {
                closeDetailView()
            }
            self.scale = 1
        }
    }
    
    private func closeDetailView() {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                isAnimationView = false
                animationContent = false
            }
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
                currentItem = nil
                showDetailPage = false
                selectedImage = "events"
            }
        self.scale = 1
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: Date())
    }
}

    
    


#Preview {
    EventsView(isTabBarHidden: .constant(true), isScrolledToBottom: .constant(false))
        .environmentObject(EventStore(locationManager: LocationDataManager()))
        .environmentObject(ProfileStore())
//    ContentView().environmentObject(EventStore(locationManager: LocationDataManager()))
//    AddContentView()
//        .colorScheme(.dark)
}


