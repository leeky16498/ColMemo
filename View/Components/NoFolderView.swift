//
//  NoMemoView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 18/04/2022.
//

import SwiftUI

struct NoFolderView: View {
    var body: some View {
        VStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 100))
                .padding()
            Text("Add your folder now, 😉")
                .font(.title.bold())
            Text("Make your memo's folder first \nby tapping '+' button!")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
        }
    }
}

struct NoMemoView_Previews: PreviewProvider {
    static var previews: some View {
        NoFolderView()
    }
}
