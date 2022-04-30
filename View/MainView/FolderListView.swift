//
//  HomeView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 17/04/2022.
//

import SwiftUI
import HalfASheet

struct FolderListView: View {
    
    @EnvironmentObject var vm : MemoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var folderName : String = ""
    @State private var showAddSheet : Bool = false
    @State private var showAlert : Bool = false
    @State private var isOnMakingFolder : Bool = false
    
    var body: some View {
        ZStack{
            NavigationView{
                ZStack{
                    if vm.folders.count == 0 {
                        NoFolderView()
                    } else {
                        List {
                            ForEach(vm.folders) { folder in
                                NavigationLink(destination: {
                                    MemoListView(folder: folder)
                                }, label: {
                                    FolderRowView(folder: folder)
                                })
                            }
                            .onDelete(perform: vm.deleteFolder)
                        }//list
                        .listStyle(.plain)
                        .listRowBackground(Color.clear)
                    }
                }
                    .navigationTitle("Folders 🗂")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                self.showAddSheet.toggle()
                            }, label: {
                                Image(systemName: "plus")
                            })
                        }
                    }
        }
            HalfASheet(isPresented: $showAddSheet) {
                halfSheetView
            }
            .height(.proportional(isOnMakingFolder ? 0.6 : 0.25))
            .contentInsets(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
    }
    .ignoresSafeArea()
}
    
    private var halfSheetView : some View {
        VStack(alignment: .leading) {
            Text("폴더명을 입력하세요 😃")
                .font(.headline.bold())
            TextField("Insert folder's name", text: $folderName, onEditingChanged: { edit in
                self.isOnMakingFolder = edit
            })
                .autocapitalization(.none)
                .disableAutocorrection(true)

            Divider()
                .padding(.bottom, 10)
            Button(action: {
                if vm.checkFolderNameCount(folderName: folderName) {
                    vm.addNewFolder(folderName: folderName)
                    self.folderName = ""
                    self.showAddSheet.toggle()
                    self.isOnMakingFolder.toggle()
                } else {
                    self.showAlert.toggle()
                }
                
            }, label: {
                Text("Save".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth : .infinity)
                    .frame(height : 50)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
            .alert(isPresented : $showAlert) {
                Alert(title: Text("Naming Error 🚫"), message: Text("Letters for folder's name is too short. Please check it one more time."), dismissButton: .cancel())
            }
            Spacer()
        }//vst
        .padding()
        .onDisappear {
            isOnMakingFolder = false
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView()
    }
}

