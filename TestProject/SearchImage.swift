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
    
    init (_ data:Dictionary<String, Any>) {
        print(data["thumbnailUrl"] ?? "no url")
        
        thumbnailUrl = URL(string:data["thumbnailUrl"] as! String)
    }
}
