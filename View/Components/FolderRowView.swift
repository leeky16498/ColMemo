//
//  FolderRowView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 17/04/2022.
//

import SwiftUI

struct FolderRowView: View {
    
    let folder : FolderModel
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.yellow)
                .font(.headline)
            Text(folder.folderName)
                .font(.headline)
            Spacer()
        }
    }
}

//struct FolderRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderRowView()
//            .previewLayout(.sizeThatFits)
//    }
//}
