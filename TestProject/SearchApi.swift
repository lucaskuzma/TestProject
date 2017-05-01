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
    
    func search(keyword:String, completion:(_ result: [SearchImage]) -> Void) {
        guard let url = URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=cats&count=10&offset=0&mkt=en-us&safeSearch=Moderate") else {
            print("Error: cannot create URL")
            return
        }
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("5db7a77b19d943f2a4cce83ce6b59502", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data,response,error in
            
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
                if let deserialized = try JSONSerialization.jsonObject(with: responseData, options: []) as? Dictionary<String, Any>
                {
                    print(deserialized)
                    print("OK: data received")
                    // completion()
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
