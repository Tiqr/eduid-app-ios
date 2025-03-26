//
//  String+Extension+AttributedString.swift
//  eduID
//
//  Created by Yasser Farahi on 26/03/2025.
//

import Foundation
import UIKit

extension String {
    func htmlAttributedString(fontFamily: String = "-apple-system", fontSize: Int) -> NSMutableAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: \(fontFamily);
                font-size: \(fontSize)px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }
        return attributedString
    }
}
