//
//  UITableViewCellExtension.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/7/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class var identifier:String {
        return String(describing: self)
    }
}
