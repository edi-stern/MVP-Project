//
//  MovieListViewModel.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import Foundation

protocol MoviesViewModelDelegate {
    func callFinished(errorMessage: String?)
    func reloadTableView()
}

class MoviesViewModel {
    var moviesListService: MoviesListServiceInterface

    var searchResults: [Movie]?

    var delegate : MoviesViewModelDelegate?
    var selectedFilter: Int? = nil

    init(moviesListService: MoviesListServiceInterface) {
        self.moviesListService = moviesListService
    }

    func getMoviesList(_ word: String) {
        selectedFilter = nil
        moviesListService.getSearchResults(word) { [weak self] (result) in
            guard let welf = self else {
                return
            }

            switch result {
            case .failure(let error):
                welf.delegate?.callFinished(errorMessage: error.localizedDescription)
            case .success(let root):
                welf.searchResults = root.results
                welf.delegate?.callFinished(errorMessage: nil)
            }
        }
    }
}
