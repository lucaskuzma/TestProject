//
//  SearchImage.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import Foundation

struct SearchImage {
    
    var thumbnailUrl:URL?
    var contentUrl:URL?
    
    init (_ data:Dictionary<String, Any>) {
        
        print(data["thumbnailUrl"] ?? "no thumbnail url")
        print(data["contentUrl"] ?? "no content url")
        
        thumbnailUrl = URL(string:data["thumbnailUrl"] as! String)
        contentUrl = URL(string:data["contentUrl"] as! String)
    }
}
