//
//  TypeInputView.swift
//  PokemonVGC
//
//  Created by Nick Cracchiolo on 9/21/18.
//  Copyright © 2018 Nick Cracchiolo. All rights reserved.
//

import UIKit

protocol TypeSuggestionDelegate: class {
    func suggestionSelected(suggestion:String?)
}

class TypeSuggestionView: UIInputView {
    var suggestions:[String] = []
    var buttons:[UIButton] = []
    weak var delegate:TypeSuggestionDelegate?
    
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTouched(_ sender:UIButton) {
        self.delegate?.suggestionSelected(suggestion: sender.titleLabel?.text)
    }
    
    override func layoutSubviews() {
        self.layoutSuggestions()
    }
    
    private func layoutSuggestions() {
        for b in buttons { b.removeFromSuperview() }
        buttons = []
        let count = suggestions.count
        for i in 0..<count {
            let sug = suggestions[i]
            let w = self.bounds.size.width / CGFloat(count)
            let frame = CGRect(x: CGFloat(i) * w , y: 0, width: w, height: self.bounds.size.height)
            let button = UIButton(frame: frame)
            button.setTitle(sug, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchDown)
            self.addSubview(button)
        }
    }
}
