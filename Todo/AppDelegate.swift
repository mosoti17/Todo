//
//  AppDelegate.swift
//  Todo
//
//  Created by Elvis Mogaka on 11/16/18.
//  Copyright © 2018 Elvis Mogaka. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        do{
        _ = try Realm()
          
        }catch{
           print("error setting up realm \(error)")
        }
       
        
        return true
    }

   

}

