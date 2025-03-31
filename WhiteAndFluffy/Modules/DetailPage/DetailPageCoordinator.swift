//
//  DetailPageCoordinator.swift
//  WhiteAndFluffy
//
//  Created by Abylaikhan Abilkayr on 31.03.2025.
//

import Foundation

protocol DetailPageCoordinatorProtocol {
    func back()
}

final class DetailPageCoordinator: DetailPageCoordinatorProtocol {
   
    private let router: RouterProtocol

    init(router: RouterProtocol) {
        self.router = router
    }
    
    
    func back() {
        router.pop(animated: true)
    }
}
