//
//  MimeType.swift
//  shared-disk (iOS)
//
//  Created by Artem Rylov on 22.05.2021.
//

import SwiftUI

enum MimeType: String {
    
    case folder = "folder"
    
    case document = "application/vnd.google-apps.document",
         spreadsheet = "application/vnd.google-apps.spreadsheet"
    
    case pdf = "application/pdf",
         txt = "text/plain"
    
    case doc = "application/msword",
         docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
         docm = "application/vnd.ms-word.document.macroEnabled.12",
         ppt = "application/vnd.ms-powerpoint",
         pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation",
         pptm = "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
    
    case png = "image/png",
         gif = "image/gif",
         jpg = "image/jpeg"
    
    case csv = "text/csv",
         csv1 = "application/csv",
         xls = "application/vnd.ms-excel",
         xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
         xlsb = "application/vnd.ms-excel.sheet.binary.macroEnabled.12",
         xlsm = "application/vnd.ms-excel.sheet.macroEnabled.12"
    
    case json = "application/json"
    
    
    case unowned
}

extension MimeType: Decodable {
    
    init(from decoder: Decoder) throws {
        self = try MimeType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unowned
    }
}

extension MimeType {
    
    var image: Image {
        switch self {
        case .folder:
            return Image(systemName: "folder.fill")
        default:
            return Image(systemName: "doc")
        }
    }
    
    var stringType: String {
        // Фолдер отдельно потому что гугл дебилы и все
        switch self {
        case .folder:
            return "application/vnd.google-apps.folder"
        default:
            return self.rawValue
        }
    }
    
    init?(fromExtention ext: String) {
        switch ext {
        case "pdf":
            self = .pdf
        case "txt":
            self = .txt
        case "doc":
            self = .doc
        case "docx":
            self = .docx
        case "ppt":
            self = .ppt
        case "pptx":
            self = .pptx
        case "png":
            self = .png
        case "gif":
            self = .gif
        case "jpg":
            self = .jpg
        case "jpeg":
            self = .jpg
        case "csv":
            self = .csv
        case "xls":
            self = .xls
        case "xlsx":
            self = .xlsx
        default:
            return nil
        }
    }
}
