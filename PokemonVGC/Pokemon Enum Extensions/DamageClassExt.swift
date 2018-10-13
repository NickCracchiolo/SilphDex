//
//  DamageClassExt.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

@available(iOS 10, *)
extension DamageClass {
    func image() -> UIImage {
        switch self {
        case .physical:
            return UIImage(named: "physical")!
        case .special:
            return UIImage(named: "special")!
        case .status:
            return UIImage(named: "status")!
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .physical:
            return UIColor(named: "PhysicalColor") ?? UIColor(red: 231.0/255.0, green: 94.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        case .special:
            return UIColor(named: "SpecialColor") ?? UIColor(red: 87.0/255.0, green: 115.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        case .status:
            return UIColor(named: "StatusColor") ?? UIColor(red: 172.0/255.0, green: 165.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        }
    }
}
