//
//  StatBar.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

class StatBar: UIView {
    private var total:CGFloat = 719.0
    private var data:[Int] = []
    
    let colors:[UIColor] = [.blue, .red, .green]
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let backRect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        backRect.close()
        UIColor.lightGray.setFill()
        backRect.fill()
        
        if data.count > 0 {
            let total:CGFloat = 1000.0
            var x:CGFloat = 0.0
            let h = self.bounds.size.height
            var i = 0
            for d in data {
                let w = self.bounds.size.width * (CGFloat(d) / total)
                let rect = UIBezierPath(rect: CGRect(x: x, y: 0, width: w, height: h))
                rect.close()
                colors[i].setFill()
                rect.fill()
                i += 1
                x += w
            }
        }
    }
    
    func set(data:[Int], total:Int) {
        self.data = data
        self.total = CGFloat(total)
        self.setNeedsDisplay()
    }
}
