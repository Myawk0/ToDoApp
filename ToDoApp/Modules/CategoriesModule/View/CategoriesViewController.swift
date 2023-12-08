//
//  CategoriesViewController.swift
//  ToDoApp
//
//  Created by Мявкo on 9.10.23.
//

import UIKit
import SnapKit
import Kingfisher

class CategoriesViewController: UIViewController {
    
    private var viewModel: CategoriesViewModelType!
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = _scrollView
    private lazy var contentView: UIView = _contentView
    private lazy var activityIndicator: UIActivityIndicatorView = _activityIndicator
    
    private lazy var kittyView: UIView = _kittyView
    private lazy var kittyImageView: UIImageView = _kittyImageView
    private lazy var kittyLabel: UILabel = _kittyLabel
    
    private lazy var collectionView: UICollectionView = _collectionView
    
    // MARK: - Properties
    
    private var collectionViewHeight = 0
    private var isTodayImageLoaded: Bool?
    
    var loadingState: LoadingState = .idle {
        didSet {
            updateActivityIndicatorState()
        }
    }
    
    // MARK: - Init
    
    init() {
        viewModel = CategoriesViewModel()
        collectionViewHeight = viewModel.dynamicHeightOfCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadCategories()
        collectionView.reloadData()
        
        loadCatImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDelegates()
        addSubviews()
        applyConstraints()
    }
    
    // MARK: - Setup Delegates
    
    private func setupDelegates() {
        RealmCategories.shared.delegate = self
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Method to load Cat Image
    
    private func loadCatImage() {
        if let savedImage = viewModel.getSavedCatImage() {
            kittyImageView.image = UIImage(data: savedImage)
        }
        loadingState = viewModel.loadingState
    }
    
    // MARK: - Method to update state of Activity Indicator
    
    private func updateActivityIndicatorState() {
        switch loadingState {
        case .idle:
            break
        case .loading:
            activityIndicator.startAnimating()
            break
        case .loaded:
            activityIndicator.stopAnimating()
            break
        }
    }
    
    // MARK: - Method to show Popup for creation a category
    
    func showPopup() {
        guard let viewModel = viewModel else { return }
        
        let popupController = CategoryPopup()
        popupController.viewModel = viewModel.viewModelForCreatingCategory()
        popupController.openPopup(from: self)
    }
    
    // MARK: - Method to show ToDo List Screen
    
    func showToDoList() {
        let navController = navigationController as? NavigationController
        let toDoController = ToDoListViewController()
        toDoController.viewModel = viewModel.viewModelForSelectedCategory()
        
        navController?.pushViewController(toDoController, animated: true)
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        kittyView.addSubview(kittyImageView)
        kittyView.addSubview(kittyLabel)
        contentView.addSubview(kittyView)
        
        contentView.addSubview(collectionView)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
        
        kittyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(200)
        }
        
        kittyImageView.snp.makeConstraints { make in
            make.height.equalTo(kittyView.snp.height).offset(-20)
            make.width.equalTo(kittyView.snp.width).dividedBy(1.5)
            make.leading.top.bottom.equalToSuperview().inset(10)
        }
        
        kittyLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(kittyImageView.snp.trailing).offset(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(kittyView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(contentView.snp.bottom)
            
            make.height.equalTo(700)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Categories.reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        
        cell.currentViewController = self
        
        cell.itemIndex = indexPath.row
        cell.viewModel = viewModel.cellViewModel(for: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showPopup()
        } else {
            viewModel.categoryIsSelected(at: indexPath.row - 1)
            showToDoList()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfItem(widthOfCollection: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumSpaceBetweenItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumSpaceBetweenItems
    }
}


// MARK: - CategoriesViewModelDelegate

extension CategoriesViewController: CategoriesViewModelDelegate {
    
    func catImageUrlIsGotten(_ imageUrl: URL?) {
        DispatchQueue.main.async {
            self.kittyImageView.kf.setImage(with: imageUrl) { [weak self] _ in
                self?.loadingState = .loaded

                if let imageData = self?.kittyImageView.image?.pngData() {
                    self?.viewModel.saveCatImage(with: imageData)
                }
            }
        }
    }
}

// MARK: - CategoriesViewController

extension CategoriesViewController: RealmCategoriesDelegate {
    
    func insertItemInCollection(at index: Int) {
        collectionView.insertItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func deleteItemFromCollection(at index: Int) {
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
}

// MARK: - Setup Elements

private extension CategoriesViewController {
    
    var _scrollView: UIScrollView {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
    
    var _contentView: UIView {
        let view = UIView()
        return view
    }
    
    var _activityIndicator: UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .darkGray
        activity.center = view.center
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        return activity
    }
    
    var _kittyView: UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow()
        return view
    }
    
    var _kittyImageView: UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    var _kittyLabel: UILabel {
        let label = UILabel()
        label.text = "Cat\nof the\nDay"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }
    
    var _collectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: K.Categories.reuseIdentifier)
        return collectionView
    }
}
