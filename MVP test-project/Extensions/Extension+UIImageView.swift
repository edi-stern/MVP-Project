//
//  Extension+UIImageView.swift
//  MVP test Project
//
//  Created by eduard.stern on 27.10.2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIImageView extension
extension UIImageView {

    func loadThumbnail(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        let networkService = NetworkService()

        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        networkService.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            self.image = UIImage(named: "loadding-spinner.pdf")
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = UIImage(data: data)
            case .failure(_):
                self.image = UIImage(named: "noImage")
            }
        }
    }
}
