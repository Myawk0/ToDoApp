//
//  CategoryCell.swift
//  ToDoApp
//
//  Created by Мявкo on 9.10.23.
//

import UIKit
import MCEmojiPicker

protocol CategoryCellDelegate: AnyObject {
    func showPopup()
}

class CategoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    var viewModel: CategoryCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            updateCell(emoji: viewModel.emoji, title: viewModel.title, count: viewModel.countTasks)
        }
    }
    
    weak var currentViewController: CategoriesViewController?
    weak var delegate: CategoryCellDelegate?
    
    private lazy var closeButton: UIButton = _closeButton
    private lazy var addButton: UIButton = _addButton
    
    private lazy var stackView: UIStackView = _stackView
    private lazy var emojiButton: UIButton = _emojiButton
    private lazy var categoryTitle: UILabel = _categoryTitle
    private lazy var countTasksLabel: UILabel = _countTasksLabel
    
    var itemIndex: Int = 0 {
        didSet {
            addButton.isHidden = itemIndex != 0
            closeButton.isHidden = itemIndex == 0
            stackView.isHidden = itemIndex == 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        contentView.addSubview(addButton)
        contentView.addSubview(closeButton)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(emojiButton)
        stackView.addArrangedSubview(categoryTitle)
        stackView.addArrangedSubview(countTasksLabel)
    }
    
    private func applyConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(13)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func setupAppearance() {
        contentView.backgroundColor = .white
        contentView.addShadow()
    }
    
    func updateCell(emoji: String, title: String, count: Int) {
        emojiButton.setTitle(emoji, for: .normal)
        categoryTitle.text = title
        
        let tasksString = count == 1 ? "task" : "tasks"
        countTasksLabel.text = "\(count) \(tasksString)"
    }
    
    @objc func emojiButtonIsTapped(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        currentViewController?.present(viewController, animated: true)
    }
    
    @objc func closeButtonIsTapped(_ sender: UIButton) {
        let alert = showAlert()
        currentViewController?.present(alert, animated: true)
    }
    
    func showAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Delete the \(categoryTitle.text ?? "")?", message: "", preferredStyle: .alert)
        
        let attributedTitle = NSAttributedString(string: "Delete the \(categoryTitle.text ?? "")?", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ])

        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.viewModel?.deleteCategory()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        return alert
    }
}

extension CategoryCell: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        viewModel?.updateCategory(emoji: emoji)
    }
}

private extension CategoryCell {
    
    var _closeButton: UIButton {
        let button = UIButton(type: .system)
        let closeImage = UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 13))
        button.setImage(closeImage, for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(closeButtonIsTapped), for: .touchUpInside)
        return button
    }
    
    var _addButton: UIButton {
        let button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(plusImage, for: .normal)
        button.tintColor = .darkGray
        button.isUserInteractionEnabled = false
        return button
    }
    
    var _stackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }
    
    var _emojiButton: UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(emojiButtonIsTapped), for: .touchUpInside)
        return button
    }
    
    var _categoryTitle: UILabel {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
    
    var _countTasksLabel: UILabel {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }
}

