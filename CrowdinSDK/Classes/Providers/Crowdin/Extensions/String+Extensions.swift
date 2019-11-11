//
//  String+Extensions.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 16.10.2019.
//

import Foundation

enum FileExtensions: String {
    case strings
    case stringsdict
}

extension String {
    var isStrings: Bool {
        return self.hasSuffix(FileExtensions.strings.rawValue)
    }
    
    var isStringsDict: Bool {
        return self.hasSuffix(FileExtensions.stringsdict.rawValue)
    }
}
