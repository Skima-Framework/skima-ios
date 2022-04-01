//
//  UIModuleProtocol.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 28/03/2022.
//

public protocol UIModule {
    static var widgets: [WidgetSchema] { get }
}
