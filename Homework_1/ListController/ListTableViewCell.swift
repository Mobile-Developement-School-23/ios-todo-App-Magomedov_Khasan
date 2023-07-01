//
//  CustomTableViewCell.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 20.06.2023.
//

import UIKit
import FileCache

final class ListTableViewCell: UITableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        let attributed = NSMutableAttributedString(string: "fuckin shleks")
//        attributed.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributed.length))
//        label.attributedText = attributed
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 15)
        label.isHidden = true
        return label
    }()
    
    private let calendarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "date")
        image.isHidden = true
        return image
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.tintColor = UIColor(named: "backgroundColor")
        return stackView
    }()
    
    private let radioButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "radioButton"), for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupLayout() {
        actions()
        setupRadioButtonLayout()
        setupTitleLabelLayout()
        setupStackViewLayout()
        setupCalendarImageLayout()
        setupDateLabelLayout()
    }
    
    private func actions() {
        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchDown)
    }
    
    @objc
    private func radioButtonTapped() {
        if radioButton.isSelected {
            radioButton.isSelected = false
            radioButton.setBackgroundImage(UIImage(named: "radioButtonDone"), for: .normal)
        } else {
            radioButton.isSelected = true
            radioButton.setBackgroundImage(UIImage(named: "radioButton"), for: .normal)
        }
    }
    
    func configure(item: ToDoItem) {
        titleLabel.text = item.text
    }
    
    func configureButton(isSelected: Bool) {
        radioButton.isSelected = true
    }
    
    private func setupRadioButtonLayout() {
        contentView.addSubview(radioButton)

        radioButton.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setupStackViewLayout() {
        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(calendarImage)
        stackView.addArrangedSubview(dateLabel)
    }
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func setupCalendarImageLayout() {
        contentView.addSubview(calendarImage)
        
        calendarImage.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12).isActive = true
        calendarImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    private func setupDateLabelLayout() {
        contentView.addSubview(dateLabel)
        
        dateLabel.leadingAnchor.constraint(equalTo: calendarImage.trailingAnchor, constant: 2).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -2).isActive = true
    }
}
