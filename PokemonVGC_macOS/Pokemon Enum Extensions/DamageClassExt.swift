//
//  DamageClassExt.swift
//  PokemonVGC_macOS
//
//  Created by Nick Cracchiolo on 9/11/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import AppKit

@available(macOS 10.11, *)
extension DamageClass {
    func image() -> NSImage {
        switch self {
        case .physical:
            return NSImage(named: "physical")!
        case .special:
            return NSImage(named: "special")!
        case .status:
            return NSImage(named: "status")!
        }
    }
}
