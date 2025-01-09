//
//  WorkersDetailView.swift
//  TownLink
//
//  Created by Ernist Isabekov on 12/22/24.
//

import SwiftUI




struct WorkerDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store = WorkerStore()
   
    var body: some View {
        List {
           
                ForEach(self.store.items, id: \.self){ item in
                    Section{
                        WorkerListCell(item: item)
                    }
                    .listSectionSpacing(10)
                }
            
        }
        .environment(\.defaultMinListRowHeight, 100)
    }
}

#Preview {
    WorkerDetailView()
}

struct WorkerListCell: View {
    var item : Worker
    var body: some View {
        HStack{
            Image(systemName: "person")
                .resizable()
                .frame(width: 45, height: 45, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.footnote)
                    .fontWeight(.black)
                    .foregroundColor(Color.gray.opacity(0.9))
                    .lineLimit(nil)
                Spacer()
                Text(item.remark)
                    .foregroundColor(Color.blue.opacity(0.4))
                    .lineLimit(1)
                    .font(.custom("ArialRoundedMTBold", size: 12))
            }
            Spacer()
            VStack{
                Text(String(item.displayDistance))
                    .foregroundColor(Color.red.opacity(0.5))
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 12, height: 12, alignment: .leading)
                    .foregroundColor(Color.blue)
                //                                .opacity(((item.isVerified) != 0) ? 1 : 0)
            }
            .font(.custom("ArialRoundedMT", size: 11))
        }
    }
}
