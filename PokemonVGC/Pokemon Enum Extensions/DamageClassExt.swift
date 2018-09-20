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
}
