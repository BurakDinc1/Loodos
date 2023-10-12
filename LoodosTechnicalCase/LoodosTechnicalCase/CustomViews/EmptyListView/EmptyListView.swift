//
//  EmptyListView.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 12.10.2023.
//

import Foundation
import UIKit

class EmptyListView: UIView {
    
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    // MARK: Common Init
    func commonInit() {
        if let viewFromXib = Bundle.main.loadNibNamed("EmptyListView",
                                                      owner: self,
                                                      options: nil)?[0] as? UIView {
            viewFromXib.frame = self.bounds
            self.addSubview(viewFromXib)
            self.setupView()
        }
    }
    
    // MARK: Setup View
    private func setupView() {
        self.mImageView.image = UIImage(named: "empty_list_icon")
        self.mLabel.text = "Henüz bu kategoride film bulunamadı. Lütfen arama yapmaya devam ediniz."
    }
    
}
