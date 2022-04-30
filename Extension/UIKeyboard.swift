//
//  UIKeyboard.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 20/04/2022.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func closeKeyboard(){
        sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for: nil)
    }
}
