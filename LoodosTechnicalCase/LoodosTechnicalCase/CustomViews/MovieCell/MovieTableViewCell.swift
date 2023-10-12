//
//  MovieTableViewCell.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 12.10.2023.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet weak var movieImdbIdLabel: UILabel!
    
    static let cellIdentify: String = "MovieTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }

    /// Icerisine aldigi MovieData ogesine gore arayuzu set eder.
    func setWith(_ movieData: MoviesData) {
        if let urlString = movieData.poster,
           let url = URL(string: urlString) {
            self.posterImageView.kf.setImage(with: url)
        }
        self.movieNameLabel.text = movieData.title ?? ""
        self.movieTypeLabel.text = movieData.type?.capitalized ?? ""
        self.movieYearLabel.text = movieData.year ?? ""
        self.movieImdbIdLabel.text = movieData.imdbID ?? ""
    }
    
    /// Arayuzun tasarimini ayarlar.
    private func setDesign() {
        self.selectionStyle = .none
        self.movieTypeLabel.font = self.movieTypeLabel.font.withSize(12)
        self.movieYearLabel.font = self.movieYearLabel.font.withSize(12)
        self.movieImdbIdLabel.font = self.movieImdbIdLabel.font.withSize(12)
        self.movieNameLabel.font = self.movieNameLabel.font.withSize(16)
        self.posterImageView.contentMode = .scaleAspectFill
        self.movieImdbIdLabel.textColor = .blue
    }
    
}
