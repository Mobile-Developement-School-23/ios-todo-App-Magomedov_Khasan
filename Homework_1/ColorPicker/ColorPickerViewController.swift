//
//  ColorPickerViewController.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 24.06.2023.
//

import UIKit

protocol ColorPickerViewControllerDelegate: AnyObject {
    func colorDidChoose(_ color: UIColor)
}

final class ColorPickerViewController: UIViewController {
    
    weak var delegate: ColorPickerViewControllerDelegate?

    private let selectedColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 30
        return view
    }()

    private let selectedColorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pickerController: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        picker.selectedColor = .red
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        updateSelectedColorCode()

        pickerController.delegate = self

        view.backgroundColor = .white
        
        doneButton.addTarget(self, action: #selector(doneButtonDidTapped), for: .touchDown)
    }

    private func updateSelectedColorCode() {
        selectedColorLabel.text = pickerController.selectedColor.hex
    }
    
    @objc
    private func doneButtonDidTapped() {
        delegate?.colorDidChoose(pickerController.selectedColor)
        dismiss(animated: true)
    }

    // MARK: - Layout

    private func setupLayout() {
        setupSelectedColorViewLayout()
        setupSelectedColorLabelLayout()
        setupDoneButtonLayout()
        setupDoneButtonLayout()
        setupColorPickerViewLayout()
    }

    private func setupSelectedColorViewLayout() {
        view.addSubview(selectedColorView)

        selectedColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        selectedColorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        selectedColorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        selectedColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
    }

    private func setupSelectedColorLabelLayout() {
        view.addSubview(selectedColorLabel)

        selectedColorLabel.leadingAnchor.constraint(equalTo: selectedColorView.trailingAnchor, constant: 4).isActive = true
        selectedColorLabel.centerYAnchor.constraint(equalTo: selectedColorView.centerYAnchor).isActive = true
    }

    private func setupDoneButtonLayout() {
        view.addSubview(doneButton)

        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
    }

    private func setupColorPickerViewLayout() {
        addChild(pickerController)

        view.addSubview(pickerController.view)

        pickerController.view.translatesAutoresizingMaskIntoConstraints = false

        pickerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerController.view.topAnchor.constraint(equalTo: selectedColorView.bottomAnchor).isActive = true
        pickerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ColorPickerViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        selectedColorView.backgroundColor = color
        updateSelectedColorCode()
    }
}
