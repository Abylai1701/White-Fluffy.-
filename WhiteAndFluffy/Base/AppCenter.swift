//
//  AppCenter.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 29.03.2025.
//

import Foundation
import UIKit

final class AppCenter {
    //MARK: - Properties
    var window: UIWindow = UIWindow()
    static let shared = AppCenter()
    
    //MARK: - Start functions
    func createWindow(_ window: UIWindow) -> Void {
        self.window = window
    }
    func start() -> Void {
        makeKeyAndVisible()
        makeRootController()
    }
    private func makeKeyAndVisible() -> Void {
        window.makeKeyAndVisible()
        window.backgroundColor = .white
    }
    func setRootController(_ controller: UIViewController) -> Void {
        window.rootViewController = controller
    }
    func makeRootController() -> Void {
        let vc = TabbarController().inNavigation()
        setRootController(vc)
    }
}
