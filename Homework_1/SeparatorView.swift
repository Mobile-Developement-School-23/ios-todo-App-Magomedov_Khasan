//
//  SeparatorView.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 23.06.2023.
//

import UIKit

final class SeparatorView: UIView {
    
    private let stackViewSeparator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        separator.tintColor = UIColor(named: "secondBackgroundColor")
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackViewSeparatorLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackViewSeparatorLayout() {
        addSubview(stackViewSeparator)
        
        stackViewSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackViewSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackViewSeparator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackViewSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackViewSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
