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
    
    private func setMovieImage() {
        DispatchQueue.main.async {
            self.movieImageView.downloadImage(self.movieDetail.posterPath ?? "")
            self.detailTableView.reloadData()
        }
    }
    
    private func setTitle(with title: String) {
        DispatchQueue.main.async {
            self.title = title
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
        case .showError(let err):
            showMessage(err)
        case .showDetail(let movieDetail):
            self.movieDetail = movieDetail
            setMovieImage()
            
        }
    }
}
