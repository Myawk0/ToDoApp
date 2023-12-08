//
//  CategoryPopup.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit
import MCEmojiPicker

class CategoryPopup: UIViewController {
    
    var viewModel: CategoryPopupViewModelType?
    
    // MARK: - Views
    
    private lazy var backgroundView: UIView = _backgroundView
    private lazy var stackView: UIStackView = _stackView
    private lazy var emojiButton: UIButton = _emojiButton
    private lazy var titleTextField: UITextField = _titleTextField
    private lazy var countTasksLabel: UILabel = _countTasksLabel
    
    private lazy var saveButton: UIButton = _saveButton
    private lazy var closeButton: UIButton = _closeButton
    
    private var blurView: UIVisualEffectView?
    private let durationOfClosing = 0.4
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = viewModel else { return }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        applyConstraints()
    }
    
    // MARK: - Selectors
    
    @objc func closeButtonIsTapped(_ sender: UIButton) {
        removeBackgroundBlur(blurView, duration: durationOfClosing)
        closePopupWithAnimation(with: durationOfClosing)
    }
    
    @objc func saveButtonIsTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, let emoji = emojiButton.currentTitle else { return }
        
        viewModel?.createCategory(title: title, emoji: emoji)
        
        removeBackgroundBlur(blurView, duration: durationOfClosing)
        closePopupWithAnimation(with: durationOfClosing)
    }
    
    @objc func emojiButtonIsTapped(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        present(viewController, animated: true)
    }
    
    // MARK: - Method to open Popup with blur background
    
    func openPopup(from controller: CategoriesViewController) {
        blurView = openingPopup(controller)
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        backgroundView.addSubview(closeButton)
        backgroundView.addSubview(stackView)
        backgroundView.addSubview(saveButton)
        
        stackView.addArrangedSubview(emojiButton)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(countTasksLabel)

        view.addSubview(backgroundView)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-26)
            make.trailing.equalToSuperview().offset(24)
            make.width.height.equalTo(60)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3.3)
            make.width.equalTo(UIScreen.main.bounds.width - 100)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - MCEmojiPickerDelegate

extension CategoryPopup: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
    }
}

// MARK: - Setting up elements

private extension CategoryPopup {
    
    var _backgroundView: UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addShadow()
        view.isUserInteractionEnabled = true
        return view
    }
    
    var _stackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .leading
        return stackView
    }

    var _emojiButton: UIButton {
        let button = UIButton()
        button.setTitle("😊", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        button.addTarget(self, action: #selector(emojiButtonIsTapped), for: .touchUpInside)
        return button
    }
    
    var _titleTextField: UITextField {
        let textField = UITextField()
        textField.placeholder = "Enter a title..."
        textField.textColor = .darkGray
        textField.font = .systemFont(ofSize: 26, weight: .bold)
        return textField
    }
    
    var _countTasksLabel: UILabel {
        let label = UILabel()
        label.text = "0 tasks"
        label.textColor = .lightGray.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }
    
    var _saveButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(saveButtonIsTapped), for: .touchUpInside)
        return button
    }
    
    var _closeButton: UIButton {
        let button = UIButton(type: .system)
        let closeImage = UIImage(systemName: "multiply.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(closeImage, for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(closeButtonIsTapped), for: .touchUpInside)
        return button
    }
}
