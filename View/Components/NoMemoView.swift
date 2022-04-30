//
//  NoMemoView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 18/04/2022.
//
import SwiftUI

struct NoMemoView: View {
    var body: some View {
        VStack {
            Image(systemName: "note.text.badge.plus")
                .foregroundColor(.blue)
                .font(.system(size: 100))
                .padding()
            Text("Add your Memos, 🥰")
                .font(.title.bold())
                .padding(.bottom, 3)
            Text("Press ' + ' button to add memo!")
                .multilineTextAlignment(.center)
                .padding()
        }
        .background(.clear)
    }
}

//struct NoMemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoMemoView()
//    }
//}
