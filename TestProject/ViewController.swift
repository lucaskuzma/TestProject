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
    let perPage:Int = 28
    var curPage:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        load(count: perPage * 2)
        
        self.title = "Revl Challenge"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let whiteBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        whiteBar.backgroundColor = .white
        self.navigationController?.view.addSubview(whiteBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCollectionView() {
        let quarterWidth = self.view.frame.size.width / 4.0 - 1
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: quarterWidth, height: quarterWidth)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0

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
    
    func load(count:Int = 0, page:Int = 0) {
        SearchApi.shared.search(keyword: "dogs", count: count > 0 ? count : perPage, offset: page * perPage, completion: {result in
            self.searchResults += result
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
        cell.image = searchResults[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row / perPage == curPage) {
            print("loading new page.. ", indexPath.row, curPage)
            curPage += 1
            load(page: curPage)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController(searchResults[indexPath.row]), animated: true)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func handleLongPress(gestureRecognizer:UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            return
        }
        
        let point = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath = (self.collectionView?.indexPathForItem(at: point))! as NSIndexPath? {
            if let url = searchResults[indexPath.row].contentUrl {
                UIPasteboard.general.copyImageAtUrl(url)
            }
        }
    }
}
