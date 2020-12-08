//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

class HabitViewController: UIViewController {
    
    // MARK: - Public properties
    
    var actionType: StyleHelper.ActionType? = .create
    var habitTitle: String?
    var habitColor: UIColor? {
        didSet {
            guard let habitColor = habitColor else { return }
            colorIndicator.backgroundColor = habitColor
        }
    }
    var habitTime: Date? {
        didSet {
            
            guard let habitTime = habitTime else { return }
            
            let formatter = DateFormatter()
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short

            timeIndicatorLabel.text = formatter.string(from: habitTime)
        }
    }
    
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
    
    private lazy var titleTextField: UITextField = {
        let titleTextField = UITextField()
        
        titleTextField.toAutoLayout()
        titleTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        titleTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        return titleTextField
    }()
    
    private let colorLabel: UILabel = {
        let colorLabel = UILabel.titleFor(input: "Цвет")
        
        colorLabel.toAutoLayout()
        
        return colorLabel
    }()
    
    private lazy var colorIndicator: UIView = {
        let colorIndicator = UIView()
        
        colorIndicator.toAutoLayout()

        colorIndicator.clipsToBounds = true
        colorIndicator.layer.cornerRadius = StyleHelper.Size.habitColorIndicator / 2
        
        colorIndicator.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapColor(_:)))
        colorIndicator.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    private lazy var colorPickerVc: UIColorPickerViewController = {
        let colorPickerVc = UIColorPickerViewController()
        
        colorPickerVc.delegate = self
        colorPickerVc.supportsAlpha = false
        
        return colorPickerVc
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    // MARK: - Keyboard life cycle
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    
    // MARK: - Private methods
    
    private func setupUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(close(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveHabit(_:)))
        
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
        
        if let habitColor = StyleHelper.Defaults.habitColor {
            self.habitColor = habitColor
            colorPickerVc.selectedColor = habitColor
        }
    }
    
    // MARK: - Actions
    
    @objc private func pickerSet(sender: UIDatePicker) {
        self.setTime(from: sender)
    }
    
    private func setTime(from datePicker: UIDatePicker) {
        habitTime = datePicker.date
    }
    
    @objc private func saveHabit(_ sender: Any) {
        
        guard let habitTitle = habitTitle,
              !habitTitle.isEmpty,
              let habitTime = habitTime,
              let habitColor = habitColor else {
            
            let alertVC = UIAlertController(title: "Невозможно сохранить привычку!", message: "Для сохранения проивычки все поля должны быть заполнены", preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
            alertVC.addAction(alertOkAction)
            navigationController?.present(alertVC, animated: true, completion: nil)
            
            return
        }

        let newHabit = Habit(name: habitTitle,
                             date: habitTime,
                             color: habitColor)
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        
        self.close(sender)
    }
    
    @objc private func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapColor(_ sender: Any) {
        navigationController?.present(colorPickerVc, animated: true, completion: nil)
    }
    
    @objc private func textFieldEditingChanged(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        habitTitle = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        habitColor = viewController.selectedColor
    }
}
