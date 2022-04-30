//
//  HomeViewModel.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 17/04/2022.
//


import SwiftUI
import Foundation

class MemoViewModel : ObservableObject {
    
    @Published var sortedMode : SortedMode?
    @Published var folders : [FolderModel] = [] {
        didSet {
            saveData()
        }
    }
    
    init() {
        getData()
    }
    
    let foldersKey = "Folders_key"
    
    func saveData() {
        if let encodedData = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encodedData, forKey: foldersKey)
        }
    }
    
    func getData() {
        guard let data = UserDefaults.standard.data(forKey: foldersKey),
              let savedData = try? JSONDecoder().decode([FolderModel].self, from: data)
        else {return}
        self.folders = savedData
    }
    
    func addNewFolder(folderName : String) {
        let newFolder = FolderModel(folderName: folderName)
        folders.append(newFolder)
    }
    
    func deleteFolder(folder : FolderModel) {
        if let index = folders.firstIndex(where: {$0.id == folder.id}) {
            folders.remove(at: index)
        }
    }
    
    func deleteFolder(indexSet : IndexSet) {
        folders.remove(atOffsets: indexSet)
    }
    
    func checkFolderNameCount(folderName : String) -> Bool {
        if folderName.count < 3 {
            return false
        } else {
            return true
        }
    }
    
    func checkMemoStatus(title : String, content : String) -> Bool {
        if title.count == 0 || content.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func addMemo(folder : FolderModel, title : String, content : String, color : Color, isImportant : String, isSecret : Bool, password : String, image : SomeImage?) {
        if let index = folders.firstIndex(where: {$0.id == folder.id}) {
            let newMemo = MemoModel(title : title, content : content, color : color, isImportant: isImportant, isSecret: isSecret, password: password, image: image)
            folders[index].memo.append(newMemo)
        }
    }
    
    func editMemo(folder : FolderModel, memo : MemoModel, title : String, content : String, color : Color, isImportant : String, isSecret : Bool, password : String, image : SomeImage?) {
        if let index = folders.firstIndex(where: {$0.id == folder.id}) {
            if let index1 = folders[index].memo.firstIndex(where: {$0.id == memo.id}) {
                folders[index].memo[index1] = memo.editMemo(title: title, content: content, color: color, isImportant: isImportant, isSecret: isSecret, password: password, image : image)
            }
        }
    }
    
    func deleteMemo(folder : FolderModel, memo : MemoModel) {
        if let index = folders.firstIndex(where: {$0.id == folder.id}) {
            if let index1 = folders[index].memo.firstIndex(where: {$0.id == memo.id}) {
                folders[index].memo.remove(at: index1)
            }
        }
    }
    
    func deleteImage(folder : FolderModel, memo : MemoModel, title : String, content : String, color : Color, isImportant : String, isSecret : Bool, password : String) {
        if let index = folders.firstIndex(where: {$0.id == folder.id}) {
            if let index1 = folders[index].memo.firstIndex(where: {$0.id == memo.id}) {
                folders[index].memo[index1] = memo.deleteImage(title: title, content: content, color: color, isImportant: isImportant, isSecret: isSecret, password: password)
            }
        }
    }
    
    func checkPassword(memo : MemoModel, password : String) -> Bool {
        if memo.password == password {
            return true
        } else {
            return false
        }
    }
    
    func sortedMemos(folder : FolderModel) {
        if let sortedMode = sortedMode {
            switch sortedMode {
            case .moreImportant:
                if let index = folders.firstIndex(where: {$0.id == folder.id}) {
                    folders[index].memo.sort(by: {$0.isImportant > $1.isImportant})
                }
            case .faster:
                if let index = folders.firstIndex(where: {$0.id == folder.id}) {
                    folders[index].memo.sort(by: {$0.timeStamp < $1.timeStamp})
                }
            case .later:
                if let index = folders.firstIndex(where: {$0.id == folder.id}) {
                    folders[index].memo.sort(by: {$0.timeStamp > $1.timeStamp})
                }
            case .lessImportant:
                if let index = folders.firstIndex(where: {$0.id == folder.id}) {
                    folders[index].memo.sort(by: {$0.isImportant > $1.isImportant})
                }
            }
        }
    }
}

enum SortedMode {
    case moreImportant, faster, later, lessImportant
}
