//
//  CollectionCell.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    func setup(withDelegate delegate:UICollectionViewDelegate, dataSource:UICollectionViewDataSource, tag:Int, cellId:String?) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = tag
        
        if let id = cellId {
            let nib = UINib(nibName: id, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: id)
        }
    }
    
    
}
