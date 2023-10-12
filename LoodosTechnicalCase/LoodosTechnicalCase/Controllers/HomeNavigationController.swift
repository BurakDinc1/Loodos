//
//  HomeNavigationController.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 11.10.2023.
//

import Foundation
import UIKit

class HomeNavigationController: UINavigationController {
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarDesign()
    }
    
    // MARK: Set Nav Bar Design
    private func setNavBarDesign() {
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.black
    }
    
}
