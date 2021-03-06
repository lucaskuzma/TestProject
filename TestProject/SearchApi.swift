//
//  SearchApi.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import Foundation

class SearchApi {
    
    static let shared = SearchApi()
    
    func search(keyword:String, count:Int = 10, offset: Int = 0, completion:@escaping (_ result: [SearchImage]) -> Void) {
        guard let url = URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=\(keyword)&count=\(count)&offset=\(offset)&mkt=en-us&safeSearch=Moderate") else {
            print("Error: cannot create URL")
            return
        }
        
        var request:URLRequest = URLRequest(url: url)
        request.setValue("5db7a77b19d943f2a4cce83ce6b59502", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data,response,error in
            
            guard error == nil else {
                print("Error")
                print(error!.localizedDescription)
                return
            }
            
            guard let responseData = data else {
                print("Error: no response data")
                return
            }
            
            do {
                if let searchResult = try JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, Any>
                {
                    print("OK: data received")

                    var output = [SearchImage]()
                    
                    if let images = searchResult["value"] {
                        let imagesCast = (images as AnyObject) as! [Dictionary<String, Any>]
                        for image in imagesCast {
                            output.append(SearchImage(image))
                        }
                    }

                    completion(output)
                } else {
                    print("Error: could not deserialize")
                }
            } catch {
                print("Error: JSONSerialization")
            }
            
        }
        
        task.resume()
    }
}
