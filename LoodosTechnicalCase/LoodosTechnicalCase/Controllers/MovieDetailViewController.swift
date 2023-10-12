//
//  MovieDetailViewController.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 12.10.2023.
//

import Foundation
import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    
    var movieDetailViewModel: MovieDetailViewModel?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet weak var movieImdbIdLabel: UILabel!
    
    // MARK: Init
    func setInitializeVM(_ movieDetailViewModel: MovieDetailViewModel) {
        self.movieDetailViewModel = movieDetailViewModel
    }
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle()
        self.setDesign()
        self.setData()
    }
    
    // MARK: View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sendThisPageToAnalytics()
    }
    
    // MARK: Send This Page To Analytics
    private func sendThisPageToAnalytics() {
        let pageName: String = "MovieDetail"
        let pageData: [String: String] = [
            "title": self.movieDetailViewModel?.movieData.title ?? "",
            "type": self.movieDetailViewModel?.movieData.type ?? "",
            "date": self.movieDetailViewModel?.movieData.year ?? ""
        ]
        FirebaseRepository.shared.sendAnalyticsLog(pageName: pageName, pageData)
    }
    
    // MARK: Set Title
    private func setTitle() {
        self.title = self.movieDetailViewModel?.movieData.title ?? "Film Detayları"
    }
    
    // MARK: Set Design
    private func setDesign() {
        self.movieTypeLabel.font = UIFont.systemFont(ofSize: 12)
        self.movieYearLabel.font = UIFont.italicSystemFont(ofSize: 12)
        self.movieImdbIdLabel.font = UIFont.systemFont(ofSize: 12)
        self.movieNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.posterImageView.contentMode = .scaleAspectFill
        self.movieImdbIdLabel.textColor = .blue
    }
    
    // MARK: Set Data
    private func setData() {
        if let urlString = self.movieDetailViewModel?.movieData.poster,
           let url = URL(string: urlString) {
            self.posterImageView.kf.setImage(with: url)
        }
        self.movieNameLabel.text = self.movieDetailViewModel?.movieData.title ?? ""
        self.movieTypeLabel.text = self.movieDetailViewModel?.movieData.type?.capitalized ?? ""
        self.movieYearLabel.text = self.movieDetailViewModel?.movieData.year ?? ""
        self.movieImdbIdLabel.text = self.movieDetailViewModel?.movieData.imdbID ?? ""
    }
    
}
