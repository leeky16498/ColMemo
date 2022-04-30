//
//  ImageView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 28/04/2022.
//

import SwiftUI

struct ImageView: View {
    
    let image : UIImage
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            }
            .padding()
            
        }
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.gray)
                    .font(.title.bold())
            })
            .padding()
            , alignment: .topTrailing
        )
        .ignoresSafeArea()
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
