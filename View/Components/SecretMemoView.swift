//
//  SecretMemoView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 27/04/2022.
//

import SwiftUI
import UIKit

struct SecretMemoView: View {
    
    @State private var password : String = ""
    @State private var isSelectedToDelete : Bool = false
    @State private var isRightPassword : Bool = false
    @State private var showAlert : Bool = false
    
    @EnvironmentObject var vm : MemoViewModel
    
    let memo : MemoModel
    let folder : FolderModel
    
    var body: some View {
        ZStack {
            HStack{
                Text("🔐 Secret Memo")
                    .font(.title2.bold())
                    .padding()
                Spacer()
                Button(action: {
                    addFolderView()
                }, label: {
                    Text("Access")
                        .font(.caption.bold())
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .zIndex(0)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Wrong password 🚫"), message: Text("Please check one more time"), dismissButton: .cancel())
                })
            }
            NavigationLink(isActive: $isRightPassword,
                           destination: {
                NewMemoView(memo: memo, folder: folder)
            },
                           label: {
                EmptyView().opacity(0.0)
            })
        }
        .background(
            Image("xmark2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.2)
                .opacity(0.2)
        )
        .buttonStyle(.plain)
        .frame(maxWidth : .infinity)
        .padding()
        .frame(height : 100)
        .background(.ultraThickMaterial)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.5), radius: 1, x: 1, y: 1)
        .onTapGesture {}
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

//struct SecretMemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecretMemoView()
//    }
//}

extension SecretMemoView {
    func addFolderView() {
        let alert = UIAlertController(title: "Security Check 🔑", message: "Type password of your memo", preferredStyle: .alert)
        
        alert.addTextField { name in
            name.placeholder = "Password"
            name.isSecureTextEntry = true
        }
        
        let addfolderAction = UIAlertAction(title: "Submit", style: .default, handler: {
            (_) in
            self.password = alert.textFields![0].text!
            if vm.checkPassword(memo: memo, password: password) {
                isRightPassword.toggle()
            } else {
                showAlert.toggle()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (_) in
        })
        
        alert.addAction(cancelAction)
        alert.addAction(addfolderAction)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
