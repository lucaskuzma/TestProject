//
//  ViewController.swift
//  TestProject
//
//  Created by lucas kuzma on 4/30/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SearchApi.shared.search(keyword: "dogs", completion: {result in
            print("callback called")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

