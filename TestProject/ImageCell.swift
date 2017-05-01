//
//  ImageCell.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var _image:SearchImage?
    
    var image:SearchImage? {
        get {
            return self._image
        }
        set(image) {
            self._image = image
            
            print("set")
        }
    }
}
