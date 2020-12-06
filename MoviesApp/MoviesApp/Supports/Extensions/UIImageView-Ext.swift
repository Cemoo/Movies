//
//  UIImageView-Ext.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import UIKit

extension UIImageView {
    func downloadImage(_ urlString: String, _ width: Int) {
        let fullUrlString = "\(app.poster_path)/w\(width)/\(urlString)"
        if let url = URL(string: fullUrlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let err = error {
                    print(err)
                } else {
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            self.image = image
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
