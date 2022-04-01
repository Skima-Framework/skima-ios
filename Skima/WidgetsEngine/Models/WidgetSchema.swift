//
//  WidgetSchema.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 24/03/2022.
//

public struct WidgetSchema {
    public let type: String
    public let view: UIWidget.Type
    public let props: WidgetPropsType.Type
    
    public init(type: String, view: UIWidget.Type, props: WidgetPropsType.Type) {
        self.type = type
        self.view = view
        self.props = props
    }
}
