//
//  MovieService.swift
//  MVP test Project
//
//  Created by eduard.stern on 27.10.2021.
//

import Foundation

protocol MoviesListServiceInterface {
    var network: NetworkServiceInterface { get }

    func getSearchResults(_ word: String, completion: @escaping NetworkResponseClosure<SearchResult>)
}

class MoviesListService: MoviesListServiceInterface {
    var network: NetworkServiceInterface = NetworkService()

    func getSearchResults(_ word: String, completion: @escaping NetworkResponseClosure<SearchResult>) {
        network.fetch(.Search(word), completion: completion)
    }
}

