/**
*  Skima Framework
*  Copyright (C) 2022 Joaquin Bozzalla
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU Affero General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU Affero General Public License for more details.
*
*  You should have received a copy of the GNU Affero General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
