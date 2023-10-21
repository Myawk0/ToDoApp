//
//  ToDoItemCell.swift
//  ToDoApp
//
//  Created by Мявкo on 10.10.23.
//

import UIKit

class ToDoItemCell: UITableViewCell {
    
    static let reuseIdentifier = "ToDoItemCell"
    
    var viewModel: ToDoItemCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            updateCell(text: viewModel.text, isSelected: viewModel.isSelected)
            needChangeLastCellApperance = viewModel.isNewItemRow
        }
    }
    
    private lazy var itemStackView: UIStackView = _itemStackView
    private lazy var checkboxButton: UIButton = _checkboxButton
    private lazy var clearButton: UIButton = _clearButton
    private lazy var itemTextField: TextField = _itemTextField
    
    private lazy var newItemStackView: UIStackView = _newItemStackView
    private lazy var plusImage: UIImageView = _plusImage
    private lazy var newItemLabel: UILabel = _newItemLabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupDelegates()
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        needToCrossOutText()
    }
    
    func setupDelegates() {
        itemTextField.delegate = self
        itemTextField.customDelegate = self
    }
    
    func updateCell(text: String, isSelected: Bool) {
        itemTextField.text = text
        checkboxButton.isSelected = isSelected
    }
    
    func hideNewItemRow(if isSearch: Bool) {
        guard let isNewItemRow = viewModel?.isNewItemRow else { return }
        
        if isNewItemRow {
            self.isHidden = isSearch
        }
    }
    
    var needChangeLastCellApperance: Bool = false {
        didSet {
            itemTextField.becomeFirstResponder()
            itemStackView.isHidden = needChangeLastCellApperance
            newItemStackView.isHidden = !needChangeLastCellApperance
        }
    }
    
    @objc private func clearButtonTapped() {
        viewModel?.taskToDelete()
    }
    
    @objc func checkboxIsTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
 
        needToCrossOutText()
        viewModel?.updateDoneState()
    }
    
    func needToCrossOutText() {
        let task = itemTextField.text ?? ""
        itemTextField.attributedText = viewModel?.updateTextAttributes(text: task, toCrossOut: checkboxButton.isSelected)
    }
    
    func makeNewTextFieldActive() {
        itemTextField.becomeFirstResponder()
    }
    
    private func addSubviews() {
        contentView.addSubview(itemStackView)
        itemStackView.addArrangedSubview(checkboxButton)
        itemStackView.addArrangedSubview(itemTextField)
        
        contentView.addSubview(newItemStackView)
        newItemStackView.addArrangedSubview(plusImage)
        newItemStackView.addArrangedSubview(newItemLabel)
    }
    
    private func applyConstraints() {
        itemStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        newItemStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        checkboxButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        
        plusImage.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
    }
}

extension ToDoItemCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            viewModel?.taskIsWrittenInTextField(with: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let indexOfAddedRow = viewModel?.textFieldReturnButtonTapped(with: textField.text ?? "")
        if viewModel?.indexPath.row == indexOfAddedRow {
            makeNewTextFieldActive()
        }
        return true
    }
}

extension ToDoItemCell: TextFieldDelegate {
    func deleteRowInTable() {
        viewModel?.taskToDelete()
    }
}

private extension ToDoItemCell {
    
    var _itemStackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.alignment = .center
        return stackView
    }
    
    var _checkboxButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checkbox"), for: .normal)
        button.setImage(UIImage(named: "selectedCheckbox"), for: .selected)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(checkboxIsTapped), for: .touchUpInside)
        return button
    }
    
    var _clearButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .darkGray
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }
    
    var _itemTextField: TextField {
        let textField = TextField()
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .never
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        textField.textColor = .darkGray
        textField.tintColor = .darkGray
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        return textField
    }
    
    var _newItemStackView: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }
    
    var _plusImage: UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.image = UIImage(systemName: "plus")
        return imageView
    }
    
    var _newItemLabel: UILabel {
        let label = UILabel()
        label.text = "New item"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }
}
