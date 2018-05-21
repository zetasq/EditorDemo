//
//  AppDelegate.swift
//  EditorDemo
//
//  Created by Zhu Shengqi on 2018/5/20.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let mainWindow = UIWindow()
    self.window = mainWindow
    
    mainWindow.rootViewController = UINavigationController(rootViewController: MainViewController())
    mainWindow.makeKeyAndVisible()
    
    return true
  }

}

