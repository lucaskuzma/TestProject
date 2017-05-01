//
//  DetailViewController.swift
//  TestProject
//
//  Created by lucas kuzma on 5/1/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let searchImage:SearchImage
    
    init(_ image: SearchImage) {
        self.searchImage = image
        super.init(nibName: nil, bundle: nil)
        loadImage()
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage() {
        if let contentUrl:URL = searchImage.contentUrl {
            let task = URLSession.shared.dataTask(with: contentUrl, completionHandler: {
                (data, response, error) in
                
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    let image = UIImage(data: data)
                    let imageView = UIImageView(image: image)
                    imageView.frame = self.view.bounds
                    self.view.addSubview(imageView)
                }
            })
            task.resume()
        }
    }
}
