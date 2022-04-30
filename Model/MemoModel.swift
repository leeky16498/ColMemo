//
//  MemoModel.swift
//  ColMemo
//
//  Created by Kyungyun Lee on 17/04/2022.
//

import SwiftUI
import Foundation

struct FolderModel : Identifiable, Codable {
    var id = UUID()
    var folderName : String
    var memo : [MemoModel] = []
}

struct MemoModel : Identifiable, Codable {
    var id = UUID()
    var title : String = "제목 없음"
    var content : String
    var color : Color = .gray
    var timeStamp : String = Date().formatted(date: .numeric, time: .omitted)
    var isImportant : String
    var isSecret : Bool = false
    var password : String?
    var image : SomeImage?

    func editMemo(title : String, content : String, color : Color, isImportant : String, isSecret : Bool, password : String, image : SomeImage?) -> MemoModel {
        return MemoModel(id: id, title: title, content: content, color: color, isImportant: isImportant, isSecret: isSecret, password: password, image: image)
    }
    
    func deleteImage(title : String, content : String, color : Color, isImportant : String, isSecret : Bool, password : String) -> MemoModel {
        return MemoModel(id: id, title: title, content: content, color: color, isImportant: isImportant, isSecret: isSecret, password: password, image: nil)
    }
}

struct SomeImage : Identifiable, Codable {
    var id = UUID()
    var image: UIImage?

    init(image: UIImage) {
        self.image = image
    }

    enum CodingKeys: CodingKey {
        case data
        case scale
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let scale = try container.decode(CGFloat.self, forKey: .scale)
        let data = try container.decode(Data.self, forKey: .data)
        self.image = UIImage(data: data, scale: scale)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let image = self.image {
            try container.encode(image.pngData(), forKey: .data)
            try container.encode(image.scale, forKey: .scale)
        }
    }
}
