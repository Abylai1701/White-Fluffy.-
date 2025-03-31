//
//  TabBarController.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 29.03.2025.
//

import Foundation
import UIKit

final class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let router = DefaultRouter()
        let coordinator = MainPageCoordinator(router: router)
        let viewModel = MainPageViewModel(coordinator: coordinator)
        let main = MainPageVC(viewModel: viewModel)
        router.currentController = main
        
        main.tabBarItem = UITabBarItem.init(title:"", image: UIImage(named: "main"), tag: 0)
        
        
        let router1 = DefaultRouter()
        let coordinator1 = FavoritesCoordinator(router: router1)
        let viewModel1 = FavoritesViewModel(coordinator: coordinator1)
        let search = FavoritesVC(viewModel: viewModel1)
        router1.currentController = search
        
        search.tabBarItem = UITabBarItem.init(title: "", image: UIImage(named: "gallery"), tag: 1)
        
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = .white
        
        self.viewControllers = [main, search]

        addTopBorderToTabBar()
    }
    private func addTopBorderToTabBar() {
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topBorder.backgroundColor = .lightGray
        tabBar.addSubview(topBorder)
    }
}
