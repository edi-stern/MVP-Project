//
//  DetailsViewModel.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import Foundation

protocol DetailsViewModelDelegate {
    func callFinished(errorMessage: String?)
    func setupFavouriteButton(text: String)
}

class DetailsViewModel {

    var movieDetails: MovieDetails?
    var isFavourite: Bool = false
    var id: String?
    var detailsService: DetailsServiceInterface
    var databaseService: DatabaseServiceInterface
    var delegate: DetailsViewModelDelegate?

    var favouriteMovies: [MovieDetails]?

    init (detailsService: DetailsServiceInterface,
          databaseService: DatabaseServiceInterface) {
        self.detailsService = detailsService
        self.databaseService = databaseService

        loadData()
    }
    
    func loadData() {
        
        if !Reachability.isConnectedToNetwork(){
            delegate?.callFinished(errorMessage: "Internet Connection not Available!")
            return
        }

        if let id = id {
            detailsService.getMovieDetails(id) { [weak self] result in
                guard let welf = self else {
                    return
                }

                switch result {
                case .failure(let error):
                    welf.delegate?.callFinished(errorMessage: error.localizedDescription)
                case .success(let root):
                    welf.movieDetails = root
                    welf.delegate?.callFinished(errorMessage: nil)
                }
            }
        } else {
            delegate?.callFinished(errorMessage: "There was an error, please try again")
        }

        databaseService.getMovies(in: Entities.Favourites, completion: { [weak self] movies in
            self?.favouriteMovies = movies
            if let id = self?.id {
                isFavourite = movies.contains { $0.id == id}
                self?.delegate?.setupFavouriteButton(text: isFavourite ? "UnFavourite" : "Favourite")
            }
        })
    }

    func favourite() {
        guard let movieDetails = movieDetails else {
            return
        }

        if isFavourite {
            databaseService.removeFavourite(movie: movieDetails)
            favouriteMovies?.removeAll {$0.id == movieDetails.id }
        } else {
            databaseService.insert(in: Entities.Favourites, movie: movieDetails)
            favouriteMovies?.append(movieDetails)
        }
        isFavourite = !isFavourite
        delegate?.setupFavouriteButton(text: isFavourite ? "UnFavourite" : "Favourite")
    }

    func hide() {
        guard let movieDetails = movieDetails else {
            return
        }
        databaseService.insert(in: Entities.Hidden,
                               movie: movieDetails)
    }
}
