//
//  File.swift
//  OrzuServiceProject
//
//  Created by MacOs User on 1/16/20.
//  Copyright © 2020 Orzu. All rights reserved.
//

import UIKit
class WebImage: UIImageView {
    func set(imageUrl:String) {
        guard let url = URL(string: imageUrl) else {return}
        if let cashedUrl = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cashedUrl.data)
            print("from cashe")
            return
        }
        print("from internet")
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data,let response = response {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data) ?? UIImage(named: "profileWhite")
                    self?.handleCashedData(data: data, response: response)
                }
            }
            print(error)
        }.resume()
    }
    func handleCashedData(data:Data,response:URLResponse) {
        guard let responseUrl = response.url else {return}
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: URLRequest(url: responseUrl))
    }
}
