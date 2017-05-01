//
//  ImageCell.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var task:URLSessionDataTask?
    var _image:SearchImage?
    
    var image:SearchImage? {
        get {
            return self._image
        }
        set(image) {
            self._image = image
            
            print("set")
            
            if let previousTask = self.task {
                previousTask.cancel()
            }
            
            if let thumbnailUrl:URL = image?.thumbnailUrl {
                self.task = URLSession.shared.dataTask(with: thumbnailUrl, completionHandler: {
                    (data, response, error) in
                    
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {
                        let thumb = UIImage(data: data)
                        let thumbView = UIImageView(image: thumb)
                        thumbView.frame = self.bounds
                        self.contentView.addSubview(thumbView)
                    }
                })
                self.task?.resume()
            }
        }
    }
}
