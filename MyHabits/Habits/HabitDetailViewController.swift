//
//  HabitDetailViewController.swift
//  MyHabits
//
//  Created by Egor Badaev on 10.12.2020.
//

import UIKit

class HabitDetailViewController: UIViewController {
    
    private var habit: Habit?
    var editCompletion: (() -> Void)?
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.toAutoLayout()
        
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: StyleHelper.ReuseIdentifier.habitDetail)
        
        return tableView
    }()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Public methods
    
    func configure(with habit: Habit) {
        self.habit = habit
        title = habit.name
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit(_:)))
        
        view.addSubview(tableView)
        view.backgroundColor = StyleHelper.Color.lightGray
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    @objc private func editHabit(_ sender: Any) {
        guard let habit = habit else { return }
        let habitVc = HabitViewController()
        habitVc.configure(with: habit)
        habitVc.completion = { [weak self] in
            
            guard let self = self else { return }
            
            self.title = habit.name
            if let editCompletion = self.editCompletion {
                editCompletion()
            }
        }
        let navigationVC = UINavigationController(rootViewController: habitVc)

        navigationController?.present(navigationVC, animated: true, completion: nil)
    }
}

//MARK: - Table View Data Source

extension HabitDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: StyleHelper.ReuseIdentifier.habitDetail)
        let date = HabitsStore.shared.dates.reversed()[indexPath.row]
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.doesRelativeDateFormatting = true

        cell.textLabel?.text = formatter.string(from: date)
        
        if let habit = habit {
            if HabitsStore.shared.habit(habit, isTrackedIn: date) {
                cell.accessoryType = .checkmark
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Активность"
    }
    
}

