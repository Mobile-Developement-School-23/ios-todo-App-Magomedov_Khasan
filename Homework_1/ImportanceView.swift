//  ImportanceView.swift
//  Homework_1
//  Created by Хасан Магомедов on 20.06.2023.

import UIKit
import FileCache

final class ImportanceView: UIView {
    
    // MARK: - UI Elements
    private let importanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Важность"
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [UIImage(named: "down")!, "нет", UIImage(named: "highness")!])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 1
        return control
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
        setupImportanceLabelLayout()
        setupSegmentedControlLayout()
    }
    
    private func setupImportanceLabelLayout() {
        addSubview(importanceLabel)
        
        importanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        importanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupSegmentedControlLayout() {
        addSubview(segmentedControl)
        
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
