//
//  CategoriesViewModelType.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

protocol CategoriesViewModelType {
    var numberOfItems: Int { get }
    var minimumSpaceBetweenItems: CGFloat { get }
    var dynamicHeightOfCollection: Int { get }
    
    var loadingState: LoadingState { get set }
    var catImageUrl: URL? { get set }
    
    var delegate: CategoriesViewModelDelegate? { get set }
    
    func cellViewModel(for indexPath: IndexPath) -> CategoryCellViewModelType?
    func sizeOfItem(widthOfCollection: CGFloat) -> CGSize
    func getSavedCatImage() -> Data?
    func saveCatImage(with image: Data)
    
    func loadCategories()
    func viewModelForCreatingCategory() -> CategoryPopupViewModelType?
    func viewModelForSelectedCategory() -> ToDoListViewModelType?
    func selectItem(at indexPath: IndexPath)
    func categoryIsSelected(at index: Int)
}
