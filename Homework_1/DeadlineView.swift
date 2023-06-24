//
//  DeadlineView.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 20.06.2023.
//

import UIKit

final class DeadlineView: UIView {
    
    //MARK: - UI Elements
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сделать до"
        //label.textColor = UIColor(named: "secondBackgroundColor")
        return label
    }()
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.isHidden = true
        label.font = label.font.withSize(13)
        //label.textColor = UIColor(named: "secondBackgroundColor")
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.tintColor = UIColor(named: "secondBackgroundColor")
        return stackView
    }()
    
    let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupLayout() {
        setupMySwitchLayout()
        setupStackViewLayout()
    }

    private func setupMySwitchLayout() {
        addSubview(mySwitch)
        
        mySwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        mySwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupStackViewLayout() {
        addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(deadlineLabel)
        stackView.addArrangedSubview(dateLabel)
    }
}
