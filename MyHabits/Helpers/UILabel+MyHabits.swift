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
}
