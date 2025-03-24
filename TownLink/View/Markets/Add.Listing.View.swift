//
//  AddListing.swift
//  TownLink
//
//  Created by Ernist Isabekov on 1/2/25.
//

import SwiftUI
import PhotosUI

struct AddListingView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isPickerPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            
            HStack{
                Text("New listing")
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
            
            if selectedImages.isEmpty {
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
                       ForEach(selectedImages, id: \.self) { image in
                           ZStack{
                               VStack{
                                   HStack{
                                       Spacer()
                                       Button(action: {
                                           // Remove the selected image
                                           if let index = selectedImages.firstIndex(of: image) {
                                               selectedImages.remove(at: index)
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
                           if selectedImages.count < 10 {
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
                       .disabled(selectedImages.count >= 10) // Disable when max images are selected
                   }
                   .padding(.horizontal)
               }
               .frame(height: 120)
           }
            VStack{
                TextField("Title", text: .constant(""))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Price", text: .constant(""))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Category", text: .constant(""))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Condition", text: .constant(""))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                TextField("Description", text: .constant(""))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Button(action: {
                    // Publish action
                }) {
                    Text("Publish")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
//
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImages: $selectedImages)
        }
    }
}



struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10 // Maximum number of images
        configuration.filter = .images // Only allow image selection

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.selectedImages.removeAll()

            let group = DispatchGroup()

            for result in results {
                group.enter()

                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    defer { group.leave() }

                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                picker.dismiss(animated: true)
            }
        }
    }
}


#Preview {
    AddListingView()
}
