//
//  Profile.View.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    @State var profile: Profile
    @EnvironmentObject var store: ProfileStore
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    var Gender = ["Not Specified", "Male", "Female", "Other"]
    var body: some View {
        NavigationStack {
           
            
            List{
                HStack{
                    Spacer()
                        AsyncImage(url: URL(string: profile.photo_url)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()  // Apply modifiers on `image`
                                    .scaledToFit()
                                    .frame(width: 100, height: 100) // Set frame here
                            case .failure:
                                Image(systemName: "photo") // Placeholder when loading fails
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView() // Show loading indicator
                                    .frame(width: 100, height: 100)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    Spacer()
                }
//                .background(.red)
//                .cornerRadius(3.0)
//                .padding()
                
                Section(header: Text("General").padding(.leading, -10)){
                    VStack(alignment: .leading) {
                        Text("First Name")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            TextField("", text: self.$profile.first_name, onEditingChanged: { isEditing in
                                if (self.profile.first_name != self.store.profile.first_name) {
                                    self.store.isChaged = true
                                }
                            }, onCommit: {
                                print("onCommit")
                            })
//                            .padding(.leading, 5)
                            
                            if (self.profile.first_name != self.store.profile.first_name) {
                                Text("X")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                       Text("Last Name")
                           .font(.subheadline)
                           .foregroundColor(.gray)
                       HStack {
                           TextField("", text: self.$profile.last_name, onEditingChanged: { isEditing in
                               if (self.profile.last_name != self.store.profile.last_name) {
                                   self.store.isChaged = true
                               }
                           }, onCommit: {
                               print("onCommit")
                           })
                       }
                   }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Gender")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Picker(selection: $profile.gender, label: Text(" ")) {
                                ForEach(0..<Gender.count) {
                                    Text(self.Gender[$0])
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            .labelsHidden()
                            //                            GenderPicker(data: Gender, notifyParentOnChangeIndex: self.$profile.gender)//.environmentObject(self.store)
                        }
                    }
                    
                    

                }
//                .listRowInsets(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 5))
                
                Section(header: Text("Contact").padding(.leading, -10)){
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            TextField("-", text: self.$profile.email, onEditingChanged: { isEditing in
                                if (self.profile.email != self.store.profile.email) {
                                    self.store.isChaged = true
                                }
                            }, onCommit: {
                                print("onCommit")
                            })
                            
                            if (self.profile.email != self.store.profile.email) {
                                Text("X")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Phone")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            TextField("-", text: self.$profile.phone_number, onEditingChanged: { isEditing in
                                if (self.profile.phone_number != self.store.profile.phone_number) {
                                    self.store.isChaged = true
                                }
                            }, onCommit: {
                                print("onCommit")
                            })
                            
                            if (self.profile.phone_number != self.store.profile.phone_number) {
                                Text("X")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Emergency Phone")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
//                            TextField("-", text: self.$profile.emergencyContact, onEditingChanged: { isEditing in
//                                if (self.profile.emergencyContact != self.store.profile.emergencyContact) {
//                                    self.store.isChaged = true
//                                }
//                            }, onCommit: {
//                                print("onCommit")
//                            })
                            
                            if (self.profile.emergency_contact != self.store.profile.emergency_contact) {
                                Text("X")
                            }
                        }
                    }
                }
                
                
                Button(action: {
                        authManager.logoutUser()
                }, label: {
                    HStack{
                        Spacer()
                        Text("Logout")
                            .font(.custom("ArialRoundedMTBold", size: 22))
                            .foregroundColor(Color.red.opacity(0.6))
                        Spacer()
                    }
                })
                
                //                    var phoneNumber, email: String
                //                    var dateOfBirth: Date
                //                    var photoURL: String
                //                    var emergencyContact: Int
                //                    var isActive, isVerified: Bool
                //                    var verifiedDocID: Int
                //                    var about: String
                //                    var dateJoined: Date
                //                    var score: Int
                //                    var lat, lon: Double
                //                    var commentsID: Int
                
//                .listRowInsets(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 10))
                
            }
            
            .navigationBarItems(
                leading:
                        Text("Profile")
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
}

#Preview {
    ProfileView(profile: ProfileStore().profile).environmentObject(ProfileStore()).environmentObject(AuthManager())
}
