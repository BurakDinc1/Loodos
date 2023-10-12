//
//  AppDelegate.swift
//  LoodosTechnicalCase
//
//  Created by Burak Dinç on 10.10.2023.
//

import UIKit
import FirebaseMessaging
import AppTrackingTransparency
import UserNotifications

// MARK: AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    // MARK: Did Finish Launch With Option
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.getConfigure()
        self.getPermissions()
        return true
    }
    
    // MARK: Initialize Configure
    private func getConfigure() {
        FirebaseRepository.shared.setConfigure()
        FirebaseRepository.shared.setupAnalytics()
        FirebaseRepository.shared.getMessaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: Get Permission
    /*
     Tum izinleri sirasi ile 1' er saniye ara ile
     gosterir. Bunun sebebi ios 14 uzerinde bu izinlerin
     arasinda zaman farkı koyulmasini istemesi.
     Aksi taktirde popup actirmiyor.
     */
    private func getPermissions() {
        self.notificationPermission {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.trackinkTransparencyPermission()
            }
        }
    }
    
    // MARK: Notification Permission
    /// Bildirim izni diyalogu.
    private func notificationPermission(completion: @escaping () -> Void) {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { status, _ in
                print("AppDelegate--> Bildirim izni durumu: \(status)")
                if(status) {
                    self.getNotificationSettings()
                }
                completion()
            }
    }
    
    // MARK: Tracking Transparency Permission
    /// Tracking Transparency izni diyalogu.
    private func trackinkTransparencyPermission() {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("AppDelegate--> Takip izni durumu: Authorized")
                case .denied:
                    print("AppDelegate--> Takip izni durumu: Denied")
                case .notDetermined:
                    print("AppDelegate--> Takip izni durumu: Not Determined")
                case .restricted:
                    print("AppDelegate--> Takip izni durumu: Restricted")
                @unknown default:
                    print("AppDelegate--> Takip izni durumu: Unknown")
                }
            }
        }
    }

    // MARK: Get Notification Settings
    /// Bildirim iznine gore Remote Notificationu aktif eder.
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print("AppDelegate--> Bildirim ayarları ayarlandı.")
            }
        }
    }
    
    // MARK: Did Receive Remote Notification
    /// Yeni bildirim geldiginde tetiklenen fonksiyon.
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        dump(userInfo, name: "AppDelegate--> Yeni Bildirim")
        completionHandler(.newData)
    }
    
    // MARK: Device Token
    /*
     Bildirim alabilmek icin cihaz tokenini firebase' in apnsToken degerine
     vermemiz gerek. Device tokeni gorebilmek için ilgili targetin info
     dosyasina "FirebaseAppDelegateProxyEnabled" degeri eklenip boolean
     olarak 0 (sifir) gonderilmelidir.
     */
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("AppDelegate--> Device Token: \(token)")
        FirebaseRepository.shared.getMessaging().apnsToken = deviceToken
    }

}

// MARK: - Messaging Delegate
extension AppDelegate: MessagingDelegate {
    
    // MARK: FCM Token
    /*
     Message delegate bildirim izninden sonra fcm token isteginde bulunur ve
     bu metod tetiklenir.
     */
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("AppDelegate--> FCM Token: \(fcmToken)")
        } else {
            print("AppDelegate--> FCM Token Alınamadı Tekrar Deneniyor !")
        }
    }
    
}
