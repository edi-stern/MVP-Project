//
//  DetailsViewController.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    let viewModel = DetailsViewModel (detailsService: DetailsService())

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadData()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DetailsViewController: DetailsViewModelDelegate {
    func callFinished(errorMessage: String?) {
        if let errorMessage = errorMessage {
            showAlert(title: "Error", message: errorMessage)
        } else if let movieDetails = viewModel.movieDetails {
            DispatchQueue.main.async { [weak self] in
                if let urlString = movieDetails.image {
                    self?.posterImageView.loadThumbnail(urlSting: urlString)
                }
                self?.titleLabel.text = "Title: \(movieDetails.fullTitle ?? "Missing")"
                self?.descriptionLabel.text = "Description: \(movieDetails.plot ?? "Missing")"
                self?.ratingLabel.text = "Rating: \(movieDetails.imDbRating ?? "Missing") ⭐️"
                self?.title = movieDetails.title
            }
        }
    }


}


