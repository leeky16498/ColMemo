//
//  ColMemoApp.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 17/04/2022.
//

import SwiftUI

@main
struct ColMemoApp: App {
    
    @StateObject var vm = MemoViewModel()
    
    var body: some Scene {
        WindowGroup {
                FolderListView()
                    .environmentObject(vm)
                    .preferredColorScheme(.light)
        }
    }
}
