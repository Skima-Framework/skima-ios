//
//  UIWidget.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

import UIKit

public protocol UIWidget: UIView {
    var widget: Widget { get }
    static var manipulators: [ActionSchema] { get }
    init(from widget: Widget)
}
