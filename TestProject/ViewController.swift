//
//  ViewController.swift
//  TestProject
//
//  Created by lucas kuzma on 4/30/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var collectionView:UICollectionView?
    var searchResults = [SearchImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCollectionView() {
        let quarterWidth = self.view.frame.size.width / 4.0 - 8
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: quarterWidth, height: quarterWidth)
        layout.minimumLineSpacing = 1.0
        layout.minimumLineSpacing = 1.0

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "DefaultCell")
        
        self.view.addSubview(collectionView!)
    }
    
    func load() {
        SearchApi.shared.search(keyword: "dogs", completion: {result in
            self.searchResults = result
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath) as! ImageCell
        cell.backgroundColor = .orange
        cell.image = searchResults[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
}
