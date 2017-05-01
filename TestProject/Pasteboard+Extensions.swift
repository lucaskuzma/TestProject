//
//  PasteboardHelper.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

extension UIPasteboard {

    func copyImageAtUrl(_ url:URL) {
        print("sharing..")
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    UIPasteboard.general.image = image
                    print("copy ok")
                } else {
                    print("copy failed")
                }
            }
        })
        task.resume()
    }
}
