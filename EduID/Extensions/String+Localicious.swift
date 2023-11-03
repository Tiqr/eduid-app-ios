//
//  String+Localicious.swift
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 09..
//

import Foundation

extension LocalizationProvider {
    var localization: String {
        return translation ?? translationKey ?? ""
    }
}
