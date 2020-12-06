//
//  MoviesVC.swift
//  MoviesApp
//
//  Created by Cemal BAYRI on 3.12.2020.
//

import UIKit

class MoviesVC: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var cellWidth: CGFloat!
    
    private var listLayout: Bool = false
    
    private var viewModel: MoviesViewModelProtocol!
    
    private var pageIndex: Int = 1
    
    private var movies: [Movie] = []
    
    private var filteringStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        viewModel = MoviesViewModel(app.service)
        viewModel.delegate = self
        viewModel.load(with: pageIndex)
    }
    
    private func setUI() {
        movieCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        movieCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func changeLayoutAction(_ sender: Any) {
        listLayout.toggle()
        movieCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        movieCollectionView.reloadData()
    }
    
    @IBAction func loadMoreAction(_ sender: Any) {
        pageIndex += 1
        viewModel.load(with: pageIndex)
    }
}

//MARK: - Search Bar Funcs
extension MoviesVC: UISearchBarDelegate {
    
    private func cancelFiltering() {
        searchBar.text = nil
        movies = viewModel.movies
        viewModel.isMoviesFiltering = false
        movieCollectionView.reloadData()
        filteringStarted = false
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       cancelFiltering()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            cancelFiltering()
            return
        }
        
        viewModel.isMoviesFiltering = true
        viewModel.filterMovies(searchText) { (movies) in
            self.movies = movies
            self.movieCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        filteringStarted = true
    }
    
}

//MARK: - Collection View Funcs
extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.movie = movies[indexPath.row]
        cell.favouriteActionDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !listLayout {
            return CGSize(width: (self.movieCollectionView.frame.width - 30) / 2, height: 250)
        } else {
            return CGSize(width: self.movieCollectionView.frame.width - 30, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerview", for: indexPath)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: self.filteringStarted ? 0 : 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        routeDetailPage(indexPath.row)
    }
    
    private func routeDetailPage(_ index: Int) {
        let movie = movies[index]
        let detailPage = MovieDetailBuilder.make(with: MovieDetailViewModel(app.service, movie: movie))
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
}

//MARK: - Add Favourites
extension MoviesVC: FavouriteStatusDelegate {
    func sendFavouriteAction(with status: Bool, movie: Movie) {
        viewModel.addRemoveFavourite(movie, status)
    }
}

extension MoviesVC: MoviesViewModelDelegate {
    func handle(_ output: MoviesOutputs) {
        switch output {
        case .showError(let err):
            showMessage(err)
        case .showMovies(let movies):
            loadMovies(movies)
        case .reload:
            movieCollectionView.reloadData()
        default: break
        }
    }
    
    private func loadMovies(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.movies = movies
            self.movieCollectionView.reloadData()
        }
    }
}

