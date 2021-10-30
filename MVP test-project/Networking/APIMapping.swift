//
//  APIMapping.swift
//  MVP test Project
//
//  Created by eduard.stern on 27.10.2021.
//

import Foundation

enum ExpectedResponseType {
    case Dictionary
}

enum HTTPMethod: String {
    case Get = "GET"
}

enum APIMapping {
    
    case Search(_ word: String)
    case GetTitlePosterRating(id: String)
}

extension APIMapping {
    
    var fullURL: URL? {
        switch self {
        default:
            return URL(string:"\(Constants.basePath)\(path)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "www.google.ro")
        }
    }

    var path: String {
        switch self {
        case .Search(let word):
            return "Search/\(Constants.apiKey)/\(word)"
        case .GetTitlePosterRating(let id):
            return "Title/\(Constants.apiKey)/\(id)/,Posters,Ratings"
        }
    }
    
    var urlRequest: URLRequest {
        guard let url = fullURL else {
            preconditionFailure("Invalid URL used to create URL instance")
        }
        return URLRequest(url: url)
    }
    
}



