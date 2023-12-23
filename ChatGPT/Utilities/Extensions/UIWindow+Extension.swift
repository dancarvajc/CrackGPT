//
//  UIWindow+Extension.swift
//  ChatGPT
//
//  Created by Daniel Carvajal on 19-08-23.
//

#if os(iOS)
import UIKit

extension UIWindow {
    static var topMostViewController: UIViewController? {
        guard let rootController = UIApplication.shared.activeWindow?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private static func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}
#endif
