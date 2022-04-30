//
//  MemoRowView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 18/04/2022.
//

import SwiftUI

struct MemoRowView: View {
    
    let memo : MemoModel
    let folder : FolderModel
    
    @State var isTapped : Bool = false
    @State var isSelectedToDelete : Bool = false
    
    @EnvironmentObject var vm : MemoViewModel
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(memo.title)
                        .font(.title2.bold())
                        .padding(.bottom, 2)
                    
                    Text(memo.content)
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment : .trailing) {

                    Text(memo.isImportant)
                        .font(.caption.bold())
                        .padding(.bottom, 3)
                    
                    Text(memo.timeStamp)
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth : .infinity)
            .padding()
            .frame(height : 100)
            .background(memo.color)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
            
            NavigationLink("", isActive: $isTapped, destination: {
                NewMemoView(memo: memo, folder: folder)
            }).opacity(0.0)
        } // zst
        .onTapGesture {
            self.isTapped.toggle()
        }
        .onLongPressGesture {
            self.isSelectedToDelete.toggle()
        }
        .confirmationDialog("Option", isPresented: $isSelectedToDelete) {
            Button(role: .destructive, action: {
                vm.deleteMemo(folder: folder, memo: memo)
            }, label: {
                Text("Delete")
            })
        }
    }
}
//
//struct MemoRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoRowView()
//            .previewLayout(.sizeThatFits)
//    }
//}
