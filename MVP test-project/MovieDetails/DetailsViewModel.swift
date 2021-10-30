//
//  DetailsViewModel.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import Foundation

protocol DetailsViewModelDelegate {
    func callFinished(errorMessage: String?)
}

class DetailsViewModel {

    var movieDetails: MovieDetails?
    var id: String?
    var detailsService: DetailsServiceInterface
    var delegate: DetailsViewModelDelegate?

    init (detailsService: DetailsServiceInterface) {
        self.detailsService = detailsService

        loadData()
    }
    
    func loadData() {
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
    }
}
