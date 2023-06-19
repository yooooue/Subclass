//
//  CollectionViewExpansionViewController.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/7/28.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit

class CollectionViewExpansionViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 30, height: 40)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = (SCREEN_WIDTH-30*4)/5
        let collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
    }

}

extension CollectionViewExpansionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
