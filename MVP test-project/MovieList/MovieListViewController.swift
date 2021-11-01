//
//  MovieListViewController.swift
//  MVP test-project
//
//  Created by eduard.stern on 30.10.2021.
//

import UIKit

class MovieListViewController: UIViewController {

    lazy var viewModel = MoviesViewModel(moviesListService: MoviesListService(), databaseService: DatabaseService())
    var selectedItem : Movie?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        viewModel.delegate = self
        title = "Movies"

        tableView.register(MovieCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 136
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
        searchBar.text = ""
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMovieDetails") {
            if let nextViewController = segue.destination as? DetailsViewController {
                nextViewController.viewModel.id = selectedItem?.id
            }
        }
    }
}

extension MovieListViewController: MoviesViewModelDelegate {
    func callFinished(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            if let errorMessage = errorMessage {
                self?.showAlert(title: "Error", message: errorMessage)
            } else {
                self?.tableView.reloadData()
            }
        }
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let c = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        c.update(item: viewModel.searchResults[indexPath.row])

        return c
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedItem = viewModel.searchResults[indexPath.row]

        performSegue(withIdentifier: "showMovieDetails", sender: self)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let word = searchBar.text else {
            return
        }
        viewModel.getMoviesList(word)
        view.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getMoviesList("")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.isEmpty {
            viewModel.getMoviesList("")
        }
    }
}

