//
//  UILabel+MyHabits.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

extension UILabel {
    static func titleFor(input title: String) -> UILabel {
        let label = UILabel()
        
        label.text = title.uppercased()
        label.font = StyleHelper.Font.footnoteCapitalized
        
        return label
    }
    
    func setText(_ text: String, animated: Bool) {
        if !animated {
            self.text = text
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.text = text
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        }
    }
}
