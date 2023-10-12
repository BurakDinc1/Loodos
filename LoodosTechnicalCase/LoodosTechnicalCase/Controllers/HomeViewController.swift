//
//  HomeViewController.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let homeViewModel: HomeViewModel = HomeViewModel()
    let emptyListView: EmptyListView = EmptyListView()
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetting()
        self.setTitle()
        self.subscribeIsLoad()
        self.subscribeList()
        self.tableViewItemSelected()
        self.tableViewBind()
    }
    
    // MARK: Set Title
    private func setTitle() {
        self.title = "Ana Sayfa"
        self.searchBar.placeholder = "Film Arayın..."
    }
    
    // MARK: Register Table View Cell
    private func initialSetting() {
        self.tableView.register(UINib(nibName: MovieTableViewCell.cellIdentify,
                                      bundle: nil),
                                forCellReuseIdentifier: MovieTableViewCell.cellIdentify)
        self.tableView.rowHeight = 100
        self.searchBar.delegate = self
    }
    
    // MARK: Table View Bind
    /// ViewModel' daki movie listin degerine gore otomatik olarak cell yerlestirir.
    private func tableViewBind() {
        self.homeViewModel
            .moviesList
            .asObservable()
            .bind(to: self.tableView
                .rx
                .items(cellIdentifier: MovieTableViewCell.cellIdentify,
                       cellType: MovieTableViewCell.self)) { (row,
                                                              movieData,
                                                              cell) in
                cell.setWith(movieData)
            }.disposed(by: self.homeViewModel.disposeBag)
    }
    
    // MARK: Table View Item Selected
    /// TableView' daki itemların tiklama aksiyonu.
    private func tableViewItemSelected() {
        self.tableView
            .rx
            .modelSelected(MoviesData.self)
            .subscribe(onNext: { [weak self] (movieData) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                vc.setInitializeVM(MovieDetailViewModel(movieData: movieData))
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.homeViewModel.disposeBag)
    }
    
    // MARK: Subscribe Is Load
    /// Yukleme animasyonuna observe olur.
    func subscribeIsLoad() {
        self.homeViewModel
            .isLoad
            .subscribe { value in
                if (value.element ?? false) {
                    self.presentLoadingView()
                } else {
                    self.dismissLoadingView()
                }
            }.disposed(by: self.homeViewModel.disposeBag)
    }
    
    // MARK: List Subscribe
    private func subscribeList() {
        self.homeViewModel
            .moviesList
            .subscribe(onNext: { [weak self] list in
                if(list.isEmpty) {
                    self?.tableView.backgroundView = self?.emptyListView
                } else {
                    self?.tableView.backgroundView = nil
                }
            }, onError: { [weak self] error in
                self?.tableView.backgroundView = nil
            }).disposed(by: self.homeViewModel.disposeBag)
    }
    
}

// MARK: Serch Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText: String = searchBar.text ?? ""
        self.homeViewModel.getMoviesByName(search: searchedText)
        self.view.endEditing(true)
    }
    
}
