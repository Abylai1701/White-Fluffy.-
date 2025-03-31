import UIKit

protocol RouterProtocol: AnyObject {
    var currentController: UIViewController? { get set }

    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToViewController(ofClass: AnyClass, animated: Bool)
    func show(_ viewController: UIViewController, completion: (() -> Void)?)
    func dismiss(completion: (() -> Void)?)
}

final class DefaultRouter: RouterProtocol {
    
    // MARK: - Properties

    var currentController: UIViewController?
    
    // MARK: - Инициализация
    init(initialViewController: UIViewController? = nil) {
        self.currentController = initialViewController
    }
    
    // MARK: - Навигационные методы
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        guard let current = currentController else {
            print("DefaultRouter: currentController is nil, cannot push.")
            return
        }
        
        if let nav = current.navigationController {
            nav.pushViewController(viewController, animated: animated)
            currentController = viewController
        }
        else if let tabBarController = current.tabBarController,
                let nav = tabBarController.navigationController {
            nav.pushViewController(viewController, animated: animated)
            currentController = viewController
        }
        else {
            print("DefaultRouter: no navigationController found, cannot push.")
        }
    }
    
    func pop(animated: Bool = true) {
        guard let current = currentController else { return }
        
        if let nav = current.navigationController {
            nav.popViewController(animated: animated)
            if let newTop = nav.viewControllers.last {
                currentController = newTop
            } else {
                currentController = nil
            }
        }
        else if let tabBarController = current.tabBarController,
                let nav = tabBarController.navigationController {
            nav.popViewController(animated: animated)
            if let newTop = nav.viewControllers.last {
                currentController = newTop
            } else {
                currentController = nil
            }
        } else {
            print("DefaultRouter: no navigationController found, cannot pop.")
        }
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        guard let current = currentController else { return }
        
        if let nav = current.navigationController {
            if let vc = nav.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
                nav.popToViewController(vc, animated: animated)
                currentController = vc
            }
        } else if let tabBarController = current.tabBarController,
                let nav = tabBarController.navigationController {
            if let vc = nav.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
                nav.popToViewController(vc, animated: animated)
                currentController = vc
            }
        } else {
            print("DefaultRouter: no navigationController found, cannot popToViewController.")
        }
    }
    
    func show(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let current = currentController else {
            print("DefaultRouter: currentController is nil, cannot show.")
            return
        }
        
        if let tabBarController = current.tabBarController {
            tabBarController.present(viewController, animated: true, completion: completion)
        } else {
            current.present(viewController, animated: true, completion: completion)
        }
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        guard let current = currentController else { return }
        
        if let nav = current.navigationController {
            nav.dismiss(animated: true, completion: completion)
        } else if let tabBarController = current.tabBarController {
            tabBarController.dismiss(animated: true, completion: completion)
        } else {
            current.dismiss(animated: true, completion: completion)
        }
    }
}
