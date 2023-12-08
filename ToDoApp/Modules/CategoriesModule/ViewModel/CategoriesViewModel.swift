//
//  CategoriesViewModel.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import UIKit

protocol CategoriesViewModelDelegate: AnyObject {
    func catImageUrlIsGotten(_ imageUrl: URL?)
}

class CategoriesViewModel: CategoriesViewModelType {
    
    // MARK: - Singletons
    
    private let realmService = RealmCategories.shared
    private let defaults = UserDefaults.standard
    
    weak var delegate: CategoriesViewModelDelegate?
    
    private var selectedIndexPath: IndexPath?
    var loadingState: LoadingState = .idle
    
    let currentDate = Date()
    var catImageUrl: URL?
    
    // MARK: - Init
    
    init() {
        CatAPIManager.shared.delegate = self
    }
    
    // MARK: - Number of categories
    
    var numberOfItems: Int {
        return (realmService.categories?.count ?? 0) + 1
    }
    
    // MARK: - Minimum space between cells
    
    var minimumSpaceBetweenItems: CGFloat {
        return 20
    }
    
    // MARK: - CategoryCellViewModel
    
    func cellViewModel(for indexPath: IndexPath) -> CategoryCellViewModelType? {
        if indexPath.row != 0 {
            if let category = realmService.categories?[indexPath.row - 1] {
                return CategoryCellViewModel(category: category, indexPath: indexPath)
            }
        }
        return nil
    }
    
    // MARK: - Size of each cell
    
    func sizeOfItem(widthOfCollection: CGFloat) -> CGSize {
        let widthItem = (widthOfCollection - 40) / 2
        let heightItem = widthItem - 30
        return CGSize(width: widthItem, height: heightItem)
    }
    
    // MARK: - Dynamic height of Collection
    
    var dynamicHeightOfCollection: Int {
        let cellsPerRow: CGFloat = 2
        let minimumSpaceBetweenItems: CGFloat = 1
        let screenWidth = UIScreen.main.bounds.width
        
        let width = (screenWidth - (cellsPerRow + 1) * minimumSpaceBetweenItems) / cellsPerRow
        let height = width - 30
        
        let totalNumberOfRows = ceil(Double(realmService.categories?.count ?? 1) / Double(cellsPerRow))
        let totalHeight = CGFloat(totalNumberOfRows) * (height + minimumSpaceBetweenItems) - minimumSpaceBetweenItems
        
        return Int(totalHeight)
    }
    
    // MARK: - Check if last saved date is today
    
    private func isToday(date: Date) -> Bool {
        return Calendar.current.isDate(currentDate, inSameDayAs: date)
    }
    
    // MARK: - Load Cat Image with logic:
    // if user opens app for the first time - load new cat image with request and save current date and cat image in UserDefaults
    // if next times user opens app, there is check: if current date is still today - load image from UserDefaults
    // else if current day is other day - load new cat image with request and save current date analogically
    
    func getSavedCatImage() -> Data? {
        guard let lastUpdateDate = defaults.object(forKey: K.Categories.lastUpdatedDateKey) as? Date,
              isToday(date: lastUpdateDate),
              let savedImage = defaults.data(forKey: K.Categories.lastCatImageKey)
        else {
            loadingState = .loading
            CatAPIManager.shared.getRandomCatImage()
            return nil
        }
        return savedImage
    }
    
    // MARK: - Save image and date to UserDefaults
    
    func saveCatImage(with imageData: Data) {
        defaults.set(imageData, forKey: K.Categories.lastCatImageKey)
        defaults.set(currentDate, forKey: K.Categories.lastUpdatedDateKey)
        defaults.synchronize()
    }
    
    // MARK: - Load categories using Realm
    
    func loadCategories() {
        realmService.loadCategories()
    }
    
    // MARK: - Method to open specific ToDo List Screen based on selected Category
    
    func categoryIsSelected(at index: Int) {
        RealmToDoItems.shared.selectedCategory = realmService.categories?[index]
    }
    
    // MARK: - Category Popup ViewModel
    
    func viewModelForCreatingCategory() -> CategoryPopupViewModelType? {
        return CategoryPopupViewModel()
    }
    
    // MARK: - ViewModel for selected category
    
    func viewModelForSelectedCategory() -> ToDoListViewModelType? {
        return ToDoListViewModel()
    }
    
    // MARK: - Select item
    
    func selectItem(at indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
}

// MARK: - CatAPIManagerDelegate

extension CategoriesViewModel: CatAPIManagerDelegate {
    
    func didFailWithError(_ APIManager: CatAPIManager, error: Error) {
        print(error)
        loadingState = .loaded
    }
    
    func getRandomCatImage(_ APIManager: CatAPIManager, catImageUrl: URL) {
        delegate?.catImageUrlIsGotten(catImageUrl)
    }
}
