//
//  NavigationEngine.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 18/03/2022.
//

import UIKit

public final class NavigationEngine {
    public static var shared = NavigationEngine()
    
    private var navigationController: UINavigationController?
    private var screensRegistry: [String: UIViewController.Type] = [:]
    
    private init() {}
    
    public func setNavigationController(_ controller: UINavigationController?) {
        navigationController = controller
    }
    
    public func registerScreen(_ vc: UIViewController.Type, withId path: String) {
        screensRegistry[path] = vc
    }
    
    public func navigate(to universalLink: String) {
        guard let vc = screensRegistry[universalLink] else { return }
        navigationController?.pushViewController(vc.init(), animated: true)
    }
    
    public func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    public func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
