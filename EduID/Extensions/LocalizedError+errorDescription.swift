//
//  LocalizedError+errorDescription.swift
//
//  Taken from: https://stackoverflow.com/a/43693876/1395437
//
//  eduID
//
//  Created by Dániel Zolnai on 2023. 06. 15..
//

import Foundation

extension LocalizedError where Self: CustomStringConvertible {

   var errorDescription: String? {
      return description
   }
}
