//
//  Movie.swift
//  MVP test Project
//
//  Created by eduard.stern on 27.10.2021.
//

import Foundation

struct SearchResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: String
    let image: String
    let title: String
    let description: String
}

struct MovieDetails: Codable {
    let id: String
    let title: String?
    let fullTitle: String?
    let plot: String?
    let errorMessage: String?
    let image: String?
    let imDbRating: String?

    var movie: Movie {
        return Movie(id: id,
                     image: image ?? "",
                     title: title ?? "Missing",
                     description: plot ?? "Missing")
    }
}
