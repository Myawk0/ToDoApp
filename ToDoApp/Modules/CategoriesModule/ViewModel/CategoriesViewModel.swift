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

enum LoadingState {
    case idle
    case loading
    case loaded
}

class CategoriesViewModel: CategoriesViewModelType {
    
    private let realmService = RealmCategories.shared
    private let defaults = UserDefaults.standard
    
    private var selectedIndexPath: IndexPath?
    
    weak var delegate: CategoriesViewModelDelegate?
    
    var loadingState: LoadingState = .idle
    
    var catImageUrl: URL?
    
    init() {
        CatAPIManager.shared.delegate = self
    }
    
    var numberOfItems: Int {
        return (realmService.categories?.count ?? 0) + 1
    }
    
    var minimumSpaceBetweenItems: CGFloat {
        return 20
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CategoryCellViewModelType? {
        if indexPath.row != 0 {
            if let category = realmService.categories?[indexPath.row - 1] {
                return CategoryCellViewModel(category: category, indexPath: indexPath)
            }
        }
        return nil
    }
    
    func sizeOfItem(widthOfCollection: CGFloat) -> CGSize {
        let widthItem = (widthOfCollection - 40) / 2
        let heightItem = widthItem - 30
        return CGSize(width: widthItem, height: heightItem)
    }
    
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
    
    func getSavedCatImage() -> Data? {
        if let savedImage = defaults.data(forKey: "lastCatImage") {
            return savedImage
        } else {
            loadingState = .loading
            CatAPIManager.shared.getRandomCatImage()
            return nil
        }
    }
    
    func saveCatImage(with imageData: Data) {
        defaults.set(imageData, forKey: "lastCatImage")
        defaults.synchronize()
    }
    
    func loadCategories() {
        realmService.loadCategories()
    }
    
    func categoryIsSelected(at index: Int) {
        RealmToDoItems.shared.selectedCategory = realmService.categories?[index]
    }
    
    func viewModelForCreatingCategory() -> CategoryPopupViewModelType? {
        return CategoryPopupViewModel()
    }
    
    func viewModelForSelectedCategory() -> ToDoListViewModelType? {
        return ToDoListViewModel()
    }
    
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
