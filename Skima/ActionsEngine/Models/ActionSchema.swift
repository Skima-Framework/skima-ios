//
//  ActionSchema.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 24/03/2022.
//

public struct ActionSchema {
    let type: String
    let actionData: ActionDataType.Type
    
    public init(type: String, actionData: ActionDataType.Type) {
        self.type = type
        self.actionData = actionData
    }
}
