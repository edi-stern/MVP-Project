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
    var databaseService: DatabaseServiceInterface

    var searchResults: [Movie] = []
    var favourites: [MovieDetails] = []
    var hiddenIds: [String] = []

    var delegate : MoviesViewModelDelegate?
    var selectedFilter: Int? = nil

    init(moviesListService: MoviesListServiceInterface, databaseService: DatabaseServiceInterface) {
        self.moviesListService = moviesListService
        self.databaseService = databaseService
    }

    func viewWillAppear() {
        getLocalMovies()
    }

    func getMoviesList(_ word: String) {
        if (word.isEmpty) {
            getLocalMovies()
            delegate?.callFinished(errorMessage: "Type something before searching")
            return
        }
        if !Reachability.isConnectedToNetwork(){
            delegate?.callFinished(errorMessage: "Internet Connection not Available!")
            return
        }
        selectedFilter = nil
        moviesListService.getSearchResults(word) { [weak self] (result) in
            guard let welf = self else {
                return
            }

            switch result {
            case .failure(let error):
                welf.delegate?.callFinished(errorMessage: error.localizedDescription)
            case .success(let root):
                welf.searchResults = root.results.filter({ [weak self] movie in
                    guard let ids = self?.hiddenIds else {
                        return true
                    }
                    return !ids.contains(movie.id)
                })

                welf.delegate?.callFinished(errorMessage: nil)
            }
        }
    }

    func getLocalMovies() {
        databaseService.getMovies(in: Entities.Favourites) { [weak self] favourites in
            self?.favourites = favourites

            databaseService.getMovies(in: Entities.Hidden) { [weak self] hiddens in
                guard let welf = self else { return }

                welf.hiddenIds = hiddens.map { $0.id }
                welf.favourites.removeAll { welf.hiddenIds.contains($0.id) }
                welf.searchResults = welf.favourites.map { $0.movie }
                welf.delegate?.callFinished(errorMessage: nil)
            }
        }
    }
}
