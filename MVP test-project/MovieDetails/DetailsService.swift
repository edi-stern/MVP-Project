//
//  DetailsService.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import Foundation

protocol DetailsServiceInterface {
    var network: NetworkServiceInterface { get }

    func getMovieDetails(_ id: String, completion: @escaping NetworkResponseClosure<MovieDetails>)
}

class DetailsService: DetailsServiceInterface {
    var network: NetworkServiceInterface = NetworkService()

    func getMovieDetails(_ id: String, completion: @escaping NetworkResponseClosure<MovieDetails>) {
        network.fetch(.GetTitlePosterRating(id: id), completion: completion)
    }
}
