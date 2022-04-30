//
//  ShareSheet.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 27/04/2022.
//

import SwiftUI
import UIKit

struct ShareSheet : UIViewControllerRepresentable {
    
    var items : [Any]
    
    func makeUIViewController(context: Context) -> some UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
         
    }
}
