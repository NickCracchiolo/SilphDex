//
//  UICollectionViewCellExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/9/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    class var identifier:String {
        return String(describing: self)
    }
}
