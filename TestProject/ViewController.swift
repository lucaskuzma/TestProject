//
//  ViewController.swift
//  TestProject
//
//  Created by lucas kuzma on 4/30/17.
//  Copyright © 2017 tsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var collectionView:UICollectionView?
    var searchResults = [SearchImage]()
    let perPage:Int = 28
    var curPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        load()
        
        self.title = "Revl Challenge"
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
        
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(longPress)
    }
    
    func load(_ page:Int = 0) {
        SearchApi.shared.search(keyword: "dogs", count: perPage, offset: page * perPage, completion: {result in
            self.searchResults += result
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
    }
    
    func handleLongPress(gestureRecognizer:UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            return
        }
        
        let point = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath = (self.collectionView?.indexPathForItem(at: point))! as NSIndexPath?{
            if let url = searchResults[indexPath.row].contentUrl {
                PasteboardHelper.shared.copyImageAtUrl(url)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row / perPage == curPage) {
            print("loading new page.. ", indexPath.row, curPage)
            curPage += 1
            load(curPage)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController(searchResults[indexPath.row]), animated: true)
    }
}
