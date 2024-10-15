//
//  String+NSRange.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 02..
//
import UIKit

extension NSAttributedString {
    func nsRange(of string: String) -> NSRange? {
        guard let range = self.string.range(of: string) else { return nil }
        return NSRange(range, in: self.string)
    }
}
