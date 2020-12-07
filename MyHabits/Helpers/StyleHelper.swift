//
//  StyleHelper.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

enum StyleHelper {

    enum Font {
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17)
        static let footnoteCapitalized = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let footnoteStatus = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let footnote = UIFont.systemFont(ofSize: 13)
        static let caption = UIFont.systemFont(ofSize: 12)
    }
    
    enum Color {
        static let accent = UIColor(named: "AccentColor")
        static let blue = UIColor(named: "HabitsBlueColor")
        static let green = UIColor(named: "HabitsGreenColor")
        static let indigo = UIColor(named: "HabitsIndigoColor")
        static let orange = UIColor(named: "HabitsOrangeColor")
        static let lightGray = UIColor(named: "LightGrayColor")
        static let gray = UIColor.systemGray2
        static let darkGray = UIColor.systemGray
    }
    
    enum Margin {
        static let large: CGFloat = 22
        static let normal: CGFloat = 16
    }
}

