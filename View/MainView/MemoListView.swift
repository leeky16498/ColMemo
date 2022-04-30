//
//  MemoView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 18/04/2022.
//

import SwiftUI

struct MemoListView: View {
    
    let folder : FolderModel
    
    @State private var showActionSheet : Bool = false
    @State private var isTapped : Bool = false
    @State private var searchText : String = ""
    
    var searchedItem : [MemoModel] {
        searchText.isEmpty ? folder.memo : folder.memo.filter({$0.title.contains(searchText)})
    }
    
    @EnvironmentObject var vm : MemoViewModel
    
    var body: some View {
        ZStack {
            if folder.memo.count == 0 {
                NoMemoView()
            } else {
                List {
                    ForEach(searchedItem) { memo in
                        if memo.isSecret {
                            SecretMemoView(memo: memo, folder: folder)
                        } else {
                            MemoRowView(memo: memo, folder: folder)
                        }
                    }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
        .navigationTitle("Memos in '\(folder.folderName)'")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink(destination: {
                        NewMemoView(memo: nil, folder: folder)
                    }, label: {
                        Image(systemName: "plus")
                    })
                    Menu(content: {
                        Button(action: {
                            vm.sortedMode = .faster
                            vm.sortedMemos(folder: folder)
                        }, label: {
                            Text("From earliest memo")
                        })
                        Button(action: {
                            vm.sortedMode = .later
                            vm.sortedMemos(folder: folder)
                        }, label: {
                            Text("From latest memo")
                        })
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
        }
    }
}

//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoListView()
//    }
//}
