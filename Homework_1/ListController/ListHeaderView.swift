//
//  ListHeaderView.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 27.06.2023.
//

import UIKit
import FileCache

final class ListHeaderView: UIView {
    
    weak var delegate: ListViewController?
    
    // MARK: - UI Elements
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.text = "Выполнены - 5"
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Показать", for: .normal)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDoneLabelLayout()
        setupShowLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupDoneLabelLayout() {
        addSubview(doneLabel)
        
        doneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        doneLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
    }
    
    private func setupShowLabelLayout() {
        addSubview(showButton)
        
        showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        showButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
    }
}
