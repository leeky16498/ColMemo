//
//  NewMemoView.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 20/04/2022.
//

import SwiftUI

struct NewMemoView: View {
    
    let folder : FolderModel
    let memo : MemoModel?
    
    @State private var items : [Any] = []
    
    @EnvironmentObject var vm : MemoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title : String = ""
    @State private var content : String = ""
    @State private var color : Color = .mint
    @State private var showAlert : Bool = false
    @State private var pickedImportance : String = "Anytime 🐳"
    @State private var isEditMode : Bool = false
    @State private var isSecret : Bool = false
    @State private var password : String = ""
    @State private var showShareSheet : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var selectedImage : UIImage?
    @State private var tappedImage : Bool = false
    @State private var showDeleteImageOption : Bool = false
    
    let importances = ["Anytime 🐳", "Normal ☀️", "Important 🔥"]
    
    var someImage : SomeImage? {
        if let selectedImage = selectedImage {
            return SomeImage(image: selectedImage)
        } else {
            return nil
        }
    }
    
    init(memo : MemoModel?, folder : FolderModel) {
        self.folder = folder
        self.memo = memo
        if let memo = memo {
            _title = State(initialValue: memo.title)
            _content = State(initialValue: memo.content)
            _color = State(initialValue: memo.color)
            _pickedImportance = State(initialValue: memo.isImportant)
            _isEditMode = State(initialValue: true)
            _isSecret = State(initialValue: memo.isSecret)
            _password = State(initialValue: memo.password ?? "")
            _selectedImage = State(initialValue: memo.image?.image)
        }
    }
    
    var body: some View {
        Form {
            Section(header : Text("Title 🔖")) {
                TextField("Input the title", text: $title)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            Section(header : Text("Importance ✅")) {
                Picker("", selection: $pickedImportance) {
                    ForEach(importances, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section(header : Text("Content ✏️(총 \(content.count) 자)")) {
                TextEditor(text: $content)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(maxWidth : .infinity)
                    .frame(height : UIScreen.main.bounds.height * 0.25)

            }
            
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
            
            Section(header : Text("Image List 🌅")) {
                HStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width : 50, height : 50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                tappedImage.toggle()
                            }
                            .onLongPressGesture(perform: {
                                showDeleteImageOption.toggle()
                            })
                            .confirmationDialog(Text("Delete Image"), isPresented: $showDeleteImageOption, actions: {
                                Button(role : .destructive, action: {
                                    vm.deleteImage(folder: folder, memo: memo!, title: title, content: content, color: color, isImportant: pickedImportance, isSecret: isSecret, password: password)
                                }, label: {
                                    Text("Delete Image")
                                })
                            })
                            .sheet(isPresented: $tappedImage) {
                                ImageView(image: self.selectedImage!)
                            }
                    } else {
                        Text("You can upload only 'one' Image")
                            .foregroundColor(.gray)
                    }
                }
                .padding(8)
            }
            
            Section(header : Text("Memo Settings ⚙️")) {
                ColorPicker("Memo Color", selection: $color, supportsOpacity: false)
                Toggle(isOn: $isSecret, label: {
                    Text("Enable Secret Mode")
                })
                
                if isSecret {
                    HStack {
                        Text("Password : ")
                        Spacer()
                        TextField("Input", text: $password)
                    }
                }
            }
            
            Button(action: {   
                if isEditMode {
                    if let memo = memo {
                        if vm.checkMemoStatus(title: title, content: content) {
                            if let someImage = someImage {
                                vm.editMemo(folder: folder, memo: memo, title: title, content: content, color: color, isImportant: pickedImportance, isSecret: isSecret, password: password, image: someImage)
                            } else {
                                vm.editMemo(folder: folder, memo: memo, title: title, content: content, color: color, isImportant: pickedImportance, isSecret: isSecret, password: password, image: nil)
                            }
                        } else {
                            showAlert.toggle()
                        }
                    }
                } else {
                    if vm.checkMemoStatus(title: title, content: content) {
                        if let someImage = someImage {
                            vm.addMemo(folder: folder, title: title, content: content, color: color, isImportant: pickedImportance, isSecret: isSecret, password: password, image: someImage)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            vm.addMemo(folder: folder, title: title, content: content, color: color, isImportant: pickedImportance, isSecret: isSecret, password: password, image: nil)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        self.showAlert.toggle()
                    }
                }
            }, label: {
                Text(isEditMode ? "Edit".uppercased() : "save".uppercased())
                    .fontWeight(.bold)
            })
            .alert(isPresented : $showAlert) {
                Alert(title: Text("Warning 🚫"), message: Text("Check your title and content, please."), dismissButton: .cancel())
            }
        }//form
        .navigationTitle("Add Memo 📒")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    share()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
                .disabled(!isEditMode)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showImagePicker.toggle()
                }, label: {
                    Image(systemName: "photo")
                })
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $selectedImage)
                }
            }
        }
    }
}

//struct NewMemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMemoView()
//    }
//}

extension NewMemoView {
    func share() {
        let content = memo?.content
        let image = memo?.image?.image
        let vc = UIActivityViewController(activityItems: [image, content], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
}
