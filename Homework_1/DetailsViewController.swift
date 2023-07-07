//
//  DetailsViewController.swift
//  Homework_1
//
//  Created by Хасан Магомедов on 20.06.2023.
//

import UIKit
import FileCache

protocol DetailsViewControllerDelegate: AnyObject {
    func handleAdd(item: ToDoItem)
}

final class DetailsViewController: UIViewController {
    
    weak var delegate: DetailsViewControllerDelegate?
    
    enum Model {
        case creation
        case editing
    }
    
    private let mode: Model
    private let item: ToDoItem?
    
    // MARK: - Examples
    private let importanceView = ImportanceView()
    private let deadlineView = DeadlineView()
    
    private let separatorView = SeparatorView()
    private let calendarSeparatorView = SeparatorView()
    private let chooseButtonSeparator = SeparatorView()
    
    private let fileCache = FileCache()
    
    private var keyboardHeight: CGFloat?
    
    private var choosedColor: UIColor?
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var customNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let saveBarButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(leaveButtonTapped))
        let cancelBarButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = saveBarButton
        navigationBar.items = [navigationItem]
        return navigationBar
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let placeholder = "Что надо cделать?"
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.layer.cornerRadius = 16
        textView.isScrollEnabled = false
        textView.backgroundColor = .white
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .white
        stackView.tintColor = UIColor(named: "secondBackgroundColor")
        return stackView
    }()
    
    private let chooseColorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выбрать цвет", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 0)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = UIDatePickerStyle.inline
        picker.isHidden = true
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchDown)
        button.tintColor = UIColor(named: "secondBackgroundColor")
        return button
    }()
    
    let formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        setupLayout()
        
        title = "Дело"
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        deadlineView.mySwitch.addTarget(self, action: #selector(mySwitchTapped), for: .valueChanged)
        
        chooseColorButton.addTarget(self, action: #selector(chooseColorButtonTapped), for: .touchDown)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    init(item: ToDoItem?) {
        if item != nil {
            mode = .editing
        } else {
            mode = .creation
        }
        self.item = item
        super.init(nibName: nil, bundle: nil)
        setupEdetingMode(item: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    init(labbel: ToDoItem?) {
//        super.init(nibName: nil, bundle: nil)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Private methods
    private func setupLayout() {
        setupCustomNavigationBarLayout()
        setupScrollViewLayout()
        setupContentViewScrollLayout()
        setupTextViewLayout()
        setupStackViewLayout()
        setupDeleteButtonLayout()
        setupDateLabelGesture()
    }
    
    private func setupEdetingMode(item: ToDoItem?) {
            guard let item = item else { return }
            
            textView.text = item.text
            textView.textColor = .black
            
            switch item.importance {
            case .important:
                importanceView.segmentedControl.selectedSegmentIndex = 2
            case .basic:
                importanceView.segmentedControl.selectedSegmentIndex = 1
            case .low:
                importanceView.segmentedControl.selectedSegmentIndex = 0
            }
            
            if let deadline = item.deadLine {
                deadlineView.mySwitch.isOn = true
                deadlineView.dateLabel.isHidden = false
                deadlineView.dateLabel.text = formatter.string(from: deadline)
            }
            
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(.systemRed, for: .normal)
        }
    
    @objc
    private func leaveButtonTapped() {
        let item = ToDoItem(text: textView.text, importance: importanceFromSelectedIndex(), isAccepted: false, deadLine: datePicker.date)
        delegate?.handleAdd(item: item)
        dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func chooseColorButtonTapped() {
        let vc = ColorPickerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        print(scrollView.contentSize)

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            keyboardHeight = nil
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            keyboardHeight = keyboardViewEndFrame.height
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        updateScrollViewOffset()
    }
    
    @objc
    private func viewTapped() {
        view.endEditing(true)
    }
    
    @objc
    private func saveButtonTapped() {
        let todoItem = ToDoItem(
            text: textView.text,
            importance: importanceFromSelectedIndex(),
            isAccepted: false,
            deadLine: datePicker.date,
            hexColor: choosedColor.flatMap { $0.hex }
        )
        fileCache.addValue(value: todoItem)
        //fileCache.writeAllToFile(toFile: "items")
    }
    
    private func importanceFromSelectedIndex() -> ToDoItem.Importance {
        if importanceView.segmentedControl.selectedSegmentIndex == 0 {
            return ToDoItem.Importance.low
        } else if importanceView.segmentedControl.selectedSegmentIndex == 1 {
            return ToDoItem.Importance.basic
        } else if importanceView.segmentedControl.selectedSegmentIndex == 2 {
            return ToDoItem.Importance.important
        }
        return .basic
    }
    
    private func setupCustomNavigationBarLayout() {
        view.addSubview(customNavigationBar)
        
        customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavigationBar.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func setupScrollViewLayout() {
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupContentViewScrollLayout() {
        scrollView.addSubview(contentView)
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupTextViewLayout() {
        contentView.addSubview(textView)
        
        textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
    }
    
    private func setupStackViewLayout() {
        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
        
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(chooseColorButton)
        stackView.addArrangedSubview(chooseButtonSeparator)
        stackView.addArrangedSubview(deadlineView)
        
        importanceView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        deadlineView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        stackView.addArrangedSubview(calendarSeparatorView)
        calendarSeparatorView.isHidden = true
        stackView.addArrangedSubview(datePicker)
    }
    
    private func setupDeleteButtonLayout() {
        contentView.addSubview(deleteButton)
        
        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        deleteButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func updateDatePickerVisibility(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.datePicker.isHidden = isHidden
        }
    }
    
    @objc
    private func deleteButtonTapped() {
        deadlineView.mySwitch.isOn = false
        deadlineView.dateLabel.isHidden = true
        
        deleteButton.setTitleColor(.lightGray, for: .normal)
        textView.text = ""
        let placeholder = "Что надо cделать?"
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.resignFirstResponder()
        
        updateDatePickerVisibility(isHidden: true)
        calendarSeparatorView.isHidden = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false 
    }
    
    @objc
    private func datePickerValueChanged() {
        let dateValue = formatter.string(from: datePicker.date)
        deadlineView.dateLabel.text = dateValue
    }
    
    @objc
    private func mySwitchTapped() {
        if deadlineView.mySwitch.isOn {
            deadlineView.dateLabel.isHidden = false
            
            deleteButton.isEnabled = false
            
            let today = Date()
            var date = Date()
            date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            
            datePicker.date = tomorrow ?? Date()
            deadlineView.dateLabel.text = formatter.string(from: date)
            deadlineView.dateLabel.isHidden = false
            
            calendarSeparatorView.isHidden = true
        } else {
            updateDatePickerVisibility(isHidden: true)
            calendarSeparatorView.isHidden = true
            
            deadlineView.dateLabel.isHidden = true
        }
    }
    
    private func setupDateLabelGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        
        deadlineView.dateLabel.addGestureRecognizer(gestureRecognizer)
        deadlineView.dateLabel.isUserInteractionEnabled = true
    }
    
    @objc
    private func dateLabelTapped() {
        if datePicker.isHidden == false {
            updateDatePickerVisibility(isHidden: true)
            calendarSeparatorView.isHidden = true
        } else {
            updateDatePickerVisibility(isHidden: false)
            calendarSeparatorView.isHidden = false
        }
    }
    
    func updateScrollViewOffset() {
        guard let keyboardHeight = keyboardHeight else {
            return
        }

        if scrollView.contentSize.height < scrollView.bounds.size.height - keyboardHeight {
            return
        }
        
        view.layoutIfNeeded()

        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - (scrollView.bounds.size.height - keyboardHeight))

        scrollView.setContentOffset(bottomOffset, animated: true)
    }
}

// MARK: - Extensions
extension DetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight(textView: textView)
        updateScrollViewOffset()
        
        if !textView.text.isEmpty {
            deleteButton.setTitleColor(.systemRed, for: .normal)
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            deleteButton.setTitleColor(.systemGray, for: .normal)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateDatePickerVisibility(isHidden: true)
        updateScrollViewOffset()
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .lightGray
        }
        updateScrollViewOffset()
        updateTextViewHeight(textView: textView)
    }
    
    private func updateTextViewHeight(textView: UITextView) {
        let size = CGSize(width: view.frame.width - 32, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height <= 120 {
                    constraint.constant = 120
                } else {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}

extension DetailsViewController: ColorPickerViewControllerDelegate {
    
    func colorDidChoose(_ color: UIColor) {
        choosedColor = color
        
        if textView.textColor != .lightGray {
            textView.textColor = color
        }
    }
}
