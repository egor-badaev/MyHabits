//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Egor Badaev on 09.12.2020.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier = "ProgressCollectionViewCell"

    // MARK: - Life cycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        contentView.backgroundColor = .red
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = StyleHelper.Radius.small
    }
    
}
