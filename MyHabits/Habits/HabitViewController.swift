//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

class HabitViewController: UIViewController {
    
    // MARK: - Properties
    
    var actionType: StyleHelper.ActionType?
    
    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.toAutoLayout()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        
        contentView.toAutoLayout()
        
        return contentView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel.titleFor(input: "Название")
        
        titleLabel.toAutoLayout()
        
        return titleLabel
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        
        titleTextField.toAutoLayout()
        
        titleTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        
        return titleTextField
    }()
    
    private let colorLabel: UILabel = {
        let colorLabel = UILabel.titleFor(input: "Цвет")
        
        colorLabel.toAutoLayout()
        
        return colorLabel
    }()
    
    private let colorIndicator: UIView = {
        let colorIndicator = UIView()
        
        colorIndicator.toAutoLayout()
        colorIndicator.backgroundColor = StyleHelper.Color.orange

        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = StyleHelper.Size.habitColorIndicator / 2
        
        return colorIndicator
    }()
    
    private let timeLabel: UILabel = {
        let timeLabel = UILabel.titleFor(input: "Время")
        
        timeLabel.toAutoLayout()
        
        return timeLabel
    }()
    
    private let timeIndicatorPrefix: UILabel = {
        let timeIndicatorPrefix = UILabel()
        
        timeIndicatorPrefix.toAutoLayout()
        timeIndicatorPrefix.text = "Каждый день в "
        timeIndicatorPrefix.font = StyleHelper.Font.body
        
        return timeIndicatorPrefix
    }()
    
    private let timeIndicatorLabel: UILabel = {
        let timeIndicatorLabel = UILabel()
        
        timeIndicatorLabel.toAutoLayout()
        timeIndicatorLabel.textColor = StyleHelper.Color.accent
        timeIndicatorLabel.font = StyleHelper.Font.body
        
        return timeIndicatorLabel
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        
        timePicker.toAutoLayout()
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        
        timePicker.addTarget(self, action: #selector(pickerSet(sender:)), for: .valueChanged)
        
        setTime(from: timePicker)
        
        return timePicker
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        if actionType == nil {
            actionType = .create
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveHabit(_:)))
        
        switch actionType {
        case .create:
            title = "Создать"
        case .edit:
            title = "Править"
        default:
            title = ""
        }
        
        view.backgroundColor = .white
        view.setupScrollSubview(scrollView, withContentView: contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorIndicator)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeIndicatorPrefix)
        contentView.addSubview(timeIndicatorLabel)
        contentView.addSubview(timePicker)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleHelper.Margin.large),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleHelper.Margin.normal),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: StyleHelper.Margin.normal),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: StyleHelper.Spacing.small),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            colorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: StyleHelper.Spacing.normal),
            colorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            colorIndicator.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: StyleHelper.Spacing.small),
            colorIndicator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            colorIndicator.widthAnchor.constraint(equalToConstant: StyleHelper.Size.habitColorIndicator),
            colorIndicator.heightAnchor.constraint(equalToConstant: StyleHelper.Size.habitColorIndicator),
            
            timeLabel.topAnchor.constraint(equalTo: colorIndicator.bottomAnchor, constant: StyleHelper.Spacing.normal),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            timeIndicatorPrefix.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: StyleHelper.Spacing.small),
            timeIndicatorPrefix.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            timeIndicatorLabel.topAnchor.constraint(equalTo: timeIndicatorPrefix.topAnchor),
            timeIndicatorLabel.leadingAnchor.constraint(equalTo: timeIndicatorPrefix.trailingAnchor),
            timeIndicatorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            timePicker.topAnchor.constraint(equalTo: timeIndicatorPrefix.bottomAnchor, constant: StyleHelper.Spacing.normal),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func pickerSet(sender: UIDatePicker) {
        self.setTime(from: sender)
    }
    
    private func setTime(from datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        timeIndicatorLabel.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func saveHabit(_ sender: Any) {
        
        //TODO: Add habit saving
        
        self.close(sender)
    }
    
    @objc private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
