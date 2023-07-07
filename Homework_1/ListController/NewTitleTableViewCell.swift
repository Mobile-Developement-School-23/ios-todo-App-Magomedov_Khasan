//
//  NewTitleTableViewCell.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 29.06.2023.
//

import UIKit


final class NewTitleTableViewCell: UITableViewCell {

    static let identifier = "NewTitleTableViewCell"
    
    private let newTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "Новое"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNewTitleLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNewTitleLabelLayout() {
        contentView.addSubview(newTitleLabel)
        
        newTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        newTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
