//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Egor Badaev on 09.12.2020.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "HabitCollectionViewCell"
    
    var trackCompletion: (() -> Void)?
    
    private var habit: Habit? {
        didSet {
            guard let habit = habit else { return }
            habitColor = habit.color
            isTracked = habit.isAlreadyTakenToday
            
            habitTitleLabel.text = habit.name
            habitTimeLabel.text = habit.dateString

            recalculateStreak()
        }
    }
    
    private var isTracked: Bool = false {
        didSet {
            if isTracked {
                habitTrackTick.backgroundColor = habitColor?.withAlphaComponent(0)
                UIView.animate(withDuration: 0.2) {
                    self.habitTrackTick.backgroundColor = self.habitColor?.withAlphaComponent(1)
                    self.habitTrackTick.layer.borderWidth = .zero
                }
            } else {
                habitTrackTick.backgroundColor = .white
                habitTrackTick.layer.borderWidth = StyleHelper.Size.habitTrackTickBorder
            }
        }
    }
    private var habitColor: UIColor? {
        didSet {
            guard let habitColor = habitColor else { return }
            habitTitleLabel.textColor = habitColor
            habitTrackTick.layer.borderColor = habitColor.cgColor

            if isTracked {
                habitTrackTick.backgroundColor = habitColor
            }
        }
    }
    
    // MARK: - Subviews
    
    private let habitTitleLabel: UILabel = {
        let habitTitleLabel = UILabel()
        
        habitTitleLabel.toAutoLayout()
        
        habitTitleLabel.font = StyleHelper.Font.headline
        
        return habitTitleLabel
    }()
    
    private let habitTimeLabel: UILabel = {
        let habitTimeLabel = UILabel()
        
        habitTimeLabel.toAutoLayout()
        
        habitTimeLabel.textColor = StyleHelper.Color.gray
        habitTimeLabel.font = StyleHelper.Font.caption
        
        return habitTimeLabel
    }()
    
    private let habitRepeatLabel: UILabel = {
        let habitRepeatLabel = UILabel()
        
        habitRepeatLabel.toAutoLayout()
        
        habitRepeatLabel.textColor = StyleHelper.Color.darkGray
        habitRepeatLabel.font = StyleHelper.Font.footnote
        
        return habitRepeatLabel
    }()
    
    private lazy var habitTrackTick: UIView = {
        let habitTrackTick = UIView()
        
        habitTrackTick.toAutoLayout()
        
        habitTrackTick.clipsToBounds = true
        habitTrackTick.layer.cornerRadius = StyleHelper.Size.habitTrackTickSize / 2
        
        habitTrackTick.isUserInteractionEnabled = true
        
        let tickImageView = UIImageView()
        tickImageView.image = #imageLiteral(resourceName: "tick_icon")
        tickImageView.backgroundColor = .clear
        tickImageView.toAutoLayout()
        
        habitTrackTick.addSubview(tickImageView)
        
        let constraints = [
            tickImageView.centerYAnchor.constraint(equalTo: habitTrackTick.centerYAnchor),
            tickImageView.centerXAnchor.constraint(equalTo: habitTrackTick.centerXAnchor),
            tickImageView.heightAnchor.constraint(equalToConstant: 15),
            tickImageView.widthAnchor.constraint(equalToConstant: 15)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTick(_:)))
        habitTrackTick.addGestureRecognizer(tapGestureRecognizer)
        
        return habitTrackTick
    }()
    
    // MARK: - Life cycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // MARK: - Public methods
    
    func configure(with habit: Habit) {
        self.habit = habit
    }
    
    // MARK: - Private methods

    private func recalculateStreak() {
        guard let habit = habit else { return }
        habitRepeatLabel.text = "Подряд: \(habit.trackDates.count)"
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = StyleHelper.Radius.large
        
        contentView.addSubview(habitTitleLabel)
        contentView.addSubview(habitTimeLabel)
        contentView.addSubview(habitRepeatLabel)
        contentView.addSubview(habitTrackTick)
        
        let constraints = [
            habitTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StyleHelper.Margin.Habit.normal),
            habitTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleHelper.Margin.Habit.normal),
            habitTimeLabel.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: StyleHelper.Spacing.smallest),
            habitTimeLabel.leadingAnchor.constraint(equalTo: habitTitleLabel.leadingAnchor),
            habitTimeLabel.trailingAnchor.constraint(equalTo: habitTitleLabel.trailingAnchor),
            habitRepeatLabel.leadingAnchor.constraint(equalTo: habitTitleLabel.leadingAnchor),
            habitRepeatLabel.trailingAnchor.constraint(equalTo: habitTitleLabel.trailingAnchor),
            habitRepeatLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -StyleHelper.Margin.Habit.normal),
            habitTrackTick.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleHelper.Margin.large),
            habitTrackTick.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            habitTrackTick.widthAnchor.constraint(equalToConstant: StyleHelper.Size.habitTrackTickSize),
            habitTrackTick.heightAnchor.constraint(equalToConstant: StyleHelper.Size.habitTrackTickSize),
            habitTrackTick.leadingAnchor.constraint(greaterThanOrEqualTo: habitTitleLabel.trailingAnchor, constant: StyleHelper.Margin.Habit.giant)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    @objc private func tapTick(_ sender: Any) {
        
        guard !isTracked else { return }
        
        isTracked = true        
        
        guard let habit = habit else { return }
        HabitsStore.shared.track(habit)
        
        UIView.animate(withDuration: 0.2) {
            self.habitRepeatLabel.alpha = 0
        } completion: { _ in
            self.recalculateStreak()
            UIView.animate(withDuration: 0.2) {
                self.habitRepeatLabel.alpha = 1
            }
        }
        
        trackCompletion?()
    }
}
