//
//  MovieDetailVC.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 5.12.2020.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    private var movieDetail: MovieDetail!
    
    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        detailTableView.register(UINib(nibName: "MovieDetailTbViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailTbViewCell")
        viewModel.load()
    }
    
    private func setUI() {
        detailTableView.tableFooterView = UIView()
    }
    
    //MARK: - Set movie poster
    private func setMovieImage() {
        DispatchQueue.main.async {
            self.movieImageView.downloadImage(self.movieDetail.posterPath ?? "", 300)
            self.detailTableView.reloadData()
        }
    }
    
    //MARK: - Set page title
    private func setTitle(with title: String) {
        DispatchQueue.main.async {
            self.title = title
        }
    }
}

//MARK: - Actions
extension MovieDetailVC {
    @IBAction func addOrRemoveFavouritesAction(_ sender: Any) {
        viewModel.addOrRemoveFavourite()
    }
}

//MARK: - Favourite Status
extension MovieDetailVC {
    private func setFavouriteButton(_ status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.favouriteButton.image = UIImage(systemName: "star.fill")
            } else {
                self.favouriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    private func changeFavouriteStatus(_ status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.showMessage("Movies App", "Movie added in favourites")
            } else {
                self.showMessage("Movies App", "Movie removed from favourites")
            }
        }
    }
}

extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "MovieDetailTbViewCell", for: indexPath) as! MovieDetailTbViewCell
        cell.index = indexPath.row
        cell.movieDetail = movieDetail
        cell.setDetails()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieDetailVC: MovieDetailViewModelDelegate {
    func handle(_ output: MovieDetailOutput) {
        switch output {
        case .setTitle(let title):
            setTitle(with: title)
        case .showMessage(let err):
            showMessage("Movies App", err)
        case .showDetail(let movieDetail):
            self.movieDetail = movieDetail
            setMovieImage()
        case .setIsFavourite(let status):
            setFavouriteButton(status)
        case .changeFavouriteStatus(let status):
            changeFavouriteStatus(status)
        }
    }
}
