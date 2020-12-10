//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Egor Badaev on 07.12.2020.
//

import UIKit

class HabitsViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        
        collectionView.toAutoLayout()
        collectionView.backgroundColor = StyleHelper.Color.lightGray
        
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
        
    @objc private func deviceDidChangeOrientation() {
        // iPad orientation change bugfix
        collectionView.reloadData()
    }

    // MARK: - Private methods
    
    private func setupUI() {
        title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit(_:)))
        
        view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    @objc private func addHabit(_ sender: Any) {
        
        let vc = HabitViewController()
        let navigationVC = UINavigationController(rootViewController: vc)

        navigationController?.present(navigationVC, animated: true, completion: nil)
        
    }

}

// MARK: - Collection View Data Source

extension HabitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return HabitsStore.shared.habits.count
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.reuseIdentifier, for: indexPath) as? ProgressCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(with: HabitsStore.shared.todayProgress)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.reuseIdentifier, for: indexPath)
            
            // TODO: configure habit cell
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }


}

// MARK: - Collection View Delegate

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: StyleHelper.Margin.large, left: StyleHelper.Margin.normal + view.safeAreaInsets.left, bottom: StyleHelper.Margin.small, right: StyleHelper.Margin.normal + view.safeAreaInsets.right)
        default:
            return UIEdgeInsets(top: StyleHelper.Spacing.normal, left: StyleHelper.Margin.normal + view.safeAreaInsets.left, bottom: StyleHelper.Margin.large, right: StyleHelper.Margin.normal + view.safeAreaInsets.right)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        StyleHelper.Spacing.normal
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        StyleHelper.Spacing.normal
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width: CGFloat
        var height: CGFloat
        
        let totalWidth = collectionView.bounds.width

        let horizontalInsets = 2 * StyleHelper.Margin.normal + view.safeAreaInsets.right + view.safeAreaInsets.left
        
        switch indexPath.section {
        
        case 0:
            height = StyleHelper.Size.progressCellHeight
            width = totalWidth - horizontalInsets
            
        default:
            height = StyleHelper.Size.habitCellHeight
            
            let numberOfColumns = Int(totalWidth / StyleHelper.Size.minimumColumnWidth)
            guard numberOfColumns > 0 else { return .zero }
            
            width = ( totalWidth - horizontalInsets - CGFloat(numberOfColumns - 1) * StyleHelper.Spacing.normal) / CGFloat(numberOfColumns)
        }
        
        return CGSize(width: width, height: height)
    }
}
