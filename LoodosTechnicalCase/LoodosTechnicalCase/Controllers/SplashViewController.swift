//
//  SplashViewController.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 10.10.2023.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDesign()
    }

    // MARK: View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (Reachability.isConnectedToNetwork()) {
            self.getRemoteConfigValue()
        } else {
            self.getAlertDialog()
        }
        
    }
    
    // MARK: Get Remote Config Value
    /// Firebase uzerinden remote config degerini alir ve label' a bastirir.
    private func getRemoteConfigValue() {
        FirebaseRepository.shared
            .getRemoteConfigValue(path: "loodos_title") { value in
                DispatchQueue.main.async {
                    self.titleLabel.text = value?.stringValue
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.presentViewController()
                }
            }
    }
    
    // MARK: Get Alert Dialog
    /// Internet baglantisi olmadigi durumlarda bir alert cikarir.
    /// Aksiyon alimlarinda programi kapatir.
    private func getAlertDialog() {
        let alert = UIAlertController(title: "Hata",
                                      message: "Lütfen internet bağlantınızı kontrol ediniz.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Kapat", style: UIAlertAction.Style.default, handler: { _ in
            exit(0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Set Design
    /// Arayuzdeki degisiklikleri ayarlar.
    private func setDesign() {
        self.titleLabel.textColor = UIColor.blue
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
        self.titleLabel.text?.removeAll()
    }
    
    // MARK: Present View Controller
    private func presentViewController() {
        let homeNavVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavigationController") as! HomeNavigationController
        homeNavVC.modalPresentationStyle = .fullScreen
        homeNavVC.modalTransitionStyle = .flipHorizontal
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeNavVC.setViewControllers([homeVC], animated: true)
        self.present(homeNavVC, animated: true, completion: nil)
    }
    
}

