//
//  Add.Event.View.swift
//  TownLink
//
//  Created by Ernist Isabekov on 2/17/25.
//

import SwiftUI

struct Add_Event_View: View {
    @Environment(\.presentationMode) var presentationMode
    @State var newEvent = EventDetail.init()
    @StateObject private var addressModel = AddressSearchViewModel()
    @EnvironmentObject var store: EventStore
    @EnvironmentObject var imageStore : ImageUploaderStore
    @State private var addressSearchPresented: Bool = false
//    @State private var selectedImages: [UIImage] = []
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack{
                Text("New event")
                    .font(.custom("TrebuchetMS-Bold", size: 20))
                    .foregroundColor(Color.blue.opacity(0.6))
                    .shadow(color: Color.blue.opacity(0.8), radius: 1)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
            }
            .padding([.trailing, .leading, .top], 10)
            

            Form{
                Section{
                    if imageStore.selectedImages.isEmpty {
                       HStack {
                           Spacer()
                           Button(action: {
                               isPickerPresented.toggle()
                           }) {
                               VStack {
                                   Image(systemName: "photo.circle")
                                       .resizable()
                                       .frame(width: 60, height: 60)
                                   Text("Add Photo")
                               }
                           }
                           Spacer()
                       }
                       .frame(height: 120) // Ensure consistent height with image row
                   } else {
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: 10) {
                               ForEach(imageStore.selectedImages, id: \.self) { image in
                                   ZStack{
                                       VStack{
                                           HStack{
                                               Spacer()
                                               Button(action: {
                                                   // Remove the selected image
                                                   if let index = imageStore.selectedImages.firstIndex(of: image) {
                                                       imageStore.selectedImages.remove(at: index)
                                                   }
                                               }) {
                                                   Image(systemName: "xmark.circle.fill")
                                                       .foregroundColor(.red)
                                                       .background(Color.white)
                                                       .clipShape(Circle())
                                               }
                                               .padding([.trailing], -7)
                                               .padding([.top], -1)
                                           }
                                           Spacer()
                                       }
                                       .zIndex(100)
                                       Image(uiImage: image)
                                           .resizable()
                                           .scaledToFill()
                                           .frame(width: 100, height: 100)
                                           .clipShape(RoundedRectangle(cornerRadius: 8))
        //                                   .padding(10)
                                   }
                               }

                               // "Add Photo" button at the end
                               Button(action: {
                                   if imageStore.selectedImages.count < 10 {
                                       isPickerPresented.toggle()
                                   }
                               }) {
                                   VStack {
                                       Image(systemName: "photo.circle")
                                           .resizable()
                                           .frame(width: 60, height: 60)
                                       Text("Add Photo")
                                   }
                               }
                               .disabled(imageStore.selectedImages.count >= 10) // Disable when max images are selected
                           }
                           .padding(.horizontal)
                       }
                       .frame(height: 120)
                   }
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                
                Section(header: Text("Basic")){
                    TextField("Name", text: $newEvent.name)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
//                    Divider()
                 
                    DatePicker("Start at", selection: $newEvent.start_time, in: Date()...)
                        .padding([.leading], 10)
                        .padding([.top, .bottom, .trailing], 5)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    DatePicker("End at ", selection: $newEvent.end_time, in: newEvent.start_time...Calendar.current.date(byAdding: .year, value: 1, to: newEvent.start_time)!)
                        .padding([.leading], 10)
                        .padding([.top, .bottom, .trailing], 5)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
                        .foregroundColor(.gray.opacity(0.5))
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//                .listRowBackground(
//                    Color(UIColor.secondarySystemGroupedBackground)
//                        .overlay(alignment: .bottom) {
//                            Divider()
//                        }
//                )
                
                Section(header: Text("Adderss"), content: {
                    Button(action: {
                        self.addressSearchPresented = true
                    }) {
                        Text(addressModel.address.isEmpty ? "Add address" : addressModel.address)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(addressModel.address.isEmpty ? Color.green : Color.green.opacity(0.7))
                            .cornerRadius(8)
                    }
                })
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                Section(header: Text("Details")){
                    TextField("Max. attendees", text: Binding(
                        get: { newEvent.max_attendees == 0 ? "" : String(newEvent.max_attendees) },  // Convert Int to String
                        set: { newEvent.max_attendees = Int($0) ?? 0 } // Convert String to Int
                    ))
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
                        
                    TextField("Ticket price", text: Binding(
                        get: { newEvent.ticket_price == 0 ? "" : String(newEvent.ticket_price) },  // Convert Int to String
                        set: { newEvent.ticket_price = Double($0) ?? 0 } // Convert String to Int
                    ))
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
                    
                    TextField("Category", text: $newEvent.category)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                            .cornerRadius(8)
                    
                    TextField("Description", text: $newEvent.description,  axis: .vertical)
                        .lineLimit(3...4)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .cornerRadius(8)
                    
                }
                .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .listRowBackground(
                    Color(UIColor.secondarySystemGroupedBackground)
                        .overlay(alignment: .bottom) {
                            Divider()
                        }
                )
               
            }
            
            
            Section {
                Button(action: {
                    self.publish()
                }) {
                    Text("Publish")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(newEvent.isValid ? Color.blue : Color.gray)
                        .cornerRadius(8)
                        .padding([.trailing, .leading], 15)
                }
                .disabled(!newEvent.isValid)
            }
            
//            if !newEvent.isValid {
//                VStack(alignment: .leading) {
//                    ForEach(newEvent.validationErrors, id: \.self) { error in
//                        Text(error)
//                            .foregroundColor(.red)
//                            .font(.caption)
//                    }
//                }
//                .padding(.top, 5)
//            }
            
        }
        
        .sheet(isPresented: $addressSearchPresented) {
            EventCreationView(addressModel: addressModel).environmentObject(addressModel)
        }
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImages: $imageStore.selectedImages)
        }
        
    }
    
    
    func publish() {
        self.newEvent.address = self.addressModel.address
        self.newEvent.latitude = self.addressModel.latitude
        self.newEvent.longitude = self.addressModel.longitude
        self.store.publishEvent(newEvent: self.newEvent) {success in
            if success {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    Add_Event_View().environmentObject(EventStore(locationManager: LocationDataManager())).environmentObject(ImageUploaderStore())
//    EventCreationView()
}


import CoreLocation

struct EventCreationView: View {
    @StateObject var addressModel: AddressSearchViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            TextField("Enter address", text: $addressModel.address)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .cornerRadius(8)
                .onChange(of: addressModel.address) {_, _ in
                    addressModel.searchForAddress()
                }
            
            if !addressModel.suggestions.isEmpty {
                List(addressModel.suggestions, id: \.id) { suggestion in
                    VStack(alignment: .leading) {
                        Text(suggestion.address)
                            .font(.headline)
                        Text("Lat: \(suggestion.latitude), Lon: \(suggestion.longitude)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        addressModel.selectAddress(suggestion)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
//                .frame(height: 200)
            }
            Spacer()
        }
        .padding()
    }
}
