//
//  AppDelegate.swift
//  PeopleDemo
//
//  Created by Adem Özsayın on 13.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _run()
        return true
    }
}

extension AppDelegate {
    private func _run() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ListPeopleViewController())
    }
}
