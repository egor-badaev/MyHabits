//
//  UIView+MyHabits.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupScrollSubview(_ scrollView: UIScrollView, withContentView contentView: UIView) {

        self.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let constraints = [
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)

    }
}
