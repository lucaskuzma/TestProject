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
    var thumbnailUrl:URL?
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    var image:SearchImage? {
        get {
            return self._image
        }
        set(image) {
            self._image = image
            
            if thumbnailUrl != image?.thumbnailUrl && image?.thumbnailUrl != nil {
                
                thumbnailUrl = image?.thumbnailUrl
                
                if let image = ImageCell.imageCache.object(forKey: thumbnailUrl!.absoluteString as NSString? ?? "") {
                    // use cached image
                    let thumbView = UIImageView(image: image)
                    thumbView.frame = self.bounds
                    self.contentView.addSubview(thumbView)
                } else {
                    // load image from server
                    self.task?.cancel()
                    self.task = URLSession.shared.dataTask(with: thumbnailUrl!, completionHandler: {
                        (data, response, error) in
                        
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async() {
                            if let thumb:UIImage = UIImage(data: data) {
                                let thumbView = UIImageView(image: thumb)
                                thumbView.frame = self.bounds
                                self.contentView.addSubview(thumbView)
                                
                                ImageCell.imageCache.setObject(thumb, forKey: self.thumbnailUrl!.absoluteString as NSString )
                            }
                        }
                    })
                    self.task?.resume()
                }
            }
        }
    }
}
