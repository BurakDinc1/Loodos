//
//  FirebaseRepository.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 10.10.2023.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseMessaging
import FirebaseRemoteConfig
import FirebaseAnalytics
import UIKit

class FirebaseRepository {
    
    static let shared = FirebaseRepository()
    
    // MARK: Init
    init(){
        print("FirebaseRepository--> Fonksiyonlar kullanıma hazır.")
    }
    
    // MARK: Set Configure
    /// Firebase temel ön yapilandirmasini calistirir.
    func setConfigure() {
        FirebaseApp.configure()
    }
    
    // MARK: Get Auth
    /// Firebase tarafında bir kullanici girisi icin tanimlanmis temel sinifi getirir.
    func getAuth() -> Auth {
        return Auth.auth()
    }
    
    // MARK: Get Database
    /// Firebase tarafinda ozelliklerine erisilebilen 'Database' sinifini getirir.
    func getDatabase() -> Database {
        let database: Database = Database.database()
        return database
    }
    
    // MARK: Get Reference
    /// Ozellikleri tanimlanan Firebase Database yapisinda ilgili yolu referans eder.
    func getReference(path: String) -> DatabaseReference {
        let reference: DatabaseReference = getDatabase().reference(withPath: path)
        return reference
    }
    
    // MARK: Get Storage Reference
    /// Ozellikleri tanimlanan Firebase Storage yapisinda ilgili yolu referans eder.
    func getStorageReference(path: String) -> StorageReference {
        return Storage.storage().reference(withPath: path)
    }
    
    // MARK: Get Current User
    /* Eger hali hazirda Firebase tarafinda bir kullanici girisi var ise
     o kullaniciyi getirir. */
    func getCurrentUser() -> User? {
        if let currentUser = self.getAuth().currentUser {
            return currentUser
        } else {
            return nil
        }
    }
    
    // MARK: Get Current User ID
    /// Eger hali hazirda girisi yapilmis kullanici var ise onun ID' sini getirir.
    func getCurrentUserID() -> String? {
        if(self.getCurrentUser() != nil) {
            return self.getCurrentUser()?.uid
        } else {
            return nil
        }
    }
    
    // MARK:  Get Device ID
    /// Mevcut cihazin ID' sini getirir. (Unique)
    func getDeviceID() -> String? {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        if (deviceID != "") {
            return deviceID
        } else {
            return nil
        }
    }
    
    // MARK: Get Messaging Object
    /// Fireabase Messaging sinifina erisim saglar.
    func getMessaging() -> Messaging {
        return Messaging.messaging()
    }
    
    // MARK: Get Remote Config Object
    /// Remote Config ogesini ayarlar ve getirir.
    private func getRemoteConfig() -> RemoteConfig {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = self.getRemoteConfigWithSettings()
        return remoteConfig
    }
    
    // MARK: Get Remote Config Settings
    /// Remote Config Settings ogesini ayarlar ve getirir.
    private func getRemoteConfigWithSettings() -> RemoteConfigSettings {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        return settings
    }
    
    // MARK: Get Remote Config Value
    /// Firebase Remote Config yolu iletilen veriyi getirir.
    func getRemoteConfigValue(path: String, completionHandler: @escaping (RemoteConfigValue?) -> Void) {
        var remoteConfigValue: RemoteConfigValue? = nil
        self.getRemoteConfig().fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else {
                print("FirebaseRepository--> Firebase Remote Config hatali bir donus aldi: \(String(describing: error?.localizedDescription))")
                completionHandler(nil)
                return
            }
            print("FirebaseRepository--> Firebase Remote Config Basarili bir sekilde dondu.")
            self.getRemoteConfig().activate { _, errorActivate in
                guard errorActivate == nil else {
                    print("FirebaseRepository--> Firebase Remote Config Activate edilemedi! Hata: \(String(describing: errorActivate?.localizedDescription))")
                    completionHandler(nil)
                    return
                }
                print("FirebaseRepository--> Firebase Remote Config degerleri isleniyor...")
                remoteConfigValue = self.getRemoteConfig().configValue(forKey: path)
                completionHandler(remoteConfigValue)
            }
        }
    }
    
    // MARK: Set Analytics Configure
    func setupAnalytics() {
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    // MARK: Send Analytics Log
    /// Analytics verileri isler.
    func sendAnalyticsLog(pageName: String, _ dictionary: [String: String]) {
        DispatchQueue.global(qos: .background).async {
            Analytics.logEvent(pageName, parameters: dictionary)
        }
    }
    
}
