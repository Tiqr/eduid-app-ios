//
//  ImageView+downloadImage.swift
//  eduID
//
//  Created by Dániel Zolnai on 2024. 10. 17..
//
import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else {
                print("Failed to load image: \(String(describing: error?.localizedDescription))")
            }
        }
        task.resume()
    }
    
    // Optional convenience method to download from a string URL
    func downloadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            downloadImage(from: url)
        }
    }
}
