//
//  AppDelegate.swift
//  Nation Wide
//
//  Created by Solution Surface on 13/06/2022.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import IQKeyboardManager
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
            guard success else {
                return
            }
            
            print("success in APNS registry")

        }
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        
        
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("token: \(token)")
        }
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }


    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let firebaseAuth = Auth.auth()
      firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)

  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      let firebaseAuth = Auth.auth()
      if (firebaseAuth.canHandleNotification(userInfo)){
          print(userInfo)
          return
      }
  }
    
}

