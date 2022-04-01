//
//  WidgetManipulatorData.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 29/03/2022.
//

open class WidgetManipulatorData: ActionDataType {
    public let widgetId: String?
    public let type: String?
    public let value: String?
    
    open func execute(from scope: Scope?) {
        fatalError("Must Override")
    }
}
