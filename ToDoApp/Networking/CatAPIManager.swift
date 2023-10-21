//
//  CatAPIManager.swift
//  ToDoApp
//
//  Created by Мявкo on 18.10.23.
//

import Foundation

protocol CatAPIManagerDelegate: AnyObject {
    func getRandomCatImage(_ APIManager: CatAPIManager, catImageUrl: URL)
    func didFailWithError(_ APIManager: CatAPIManager, error: Error)
}

class CatAPIManager {
    
    static let shared = CatAPIManager()
    
    weak var delegate: CatAPIManagerDelegate?
    
    func fetchCatImage(completion: @escaping (Result<URL, NetworkError>) -> Void) {
        guard let url = NetworkManager.shared.createURL(for: .randomCatImage) else { return }
        
        NetworkManager.shared.makeTask(for: url) { (result: Result<[CatData], NetworkError>) in
            switch result {
            case .success(let catDataArray):
                if let catData = catDataArray.first, let imageUrl = URL(string: catData.url) {
                    completion(.success(imageUrl))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRandomCatImage() {
        fetchCatImage { result in
            switch result {
            case .success(let imageUrl):
                self.delegate?.getRandomCatImage(self, catImageUrl: imageUrl)
            case .failure(let error):
                self.delegate?.didFailWithError(self, error: error)
            }
        }
    }
}
