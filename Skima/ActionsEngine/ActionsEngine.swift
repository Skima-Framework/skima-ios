//
//  ActionsEngine.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

public final class ActionsEngine {
    
    public static let shared = ActionsEngine()
    
    private init() {}
    
    private var actionsRegistry: [ActionSchema] = []
    
    public func getIfExist(type: String?) -> ActionSchema? {
        guard let _type = type else { return nil }
        return actionsRegistry.first { $0.type == _type }
    }
    
    public func registerOrReplace(_ action: ActionSchema) {
        if let index = actionsRegistry.firstIndex(where: { $0.type == action.type }) {
            actionsRegistry[index] = action
        } else {
            actionsRegistry.append(action)
        }
    }
    
    public func registerOrReplace(_ actions: [ActionSchema]) {
        actions.forEach { registerOrReplace($0) }
    }
    
    public func registerOrReplace(_ module: ActionsModule.Type) {
        registerOrReplace(module.actions)
    }
    
    public func registerIfNotExist(_ action: ActionSchema) {
        guard getIfExist(type: action.type) != nil else { return }
        registerOrReplace(action)
    }
    
    public func registerIfNotExist(_ actions: [ActionSchema]) {
        actions.forEach { registerIfNotExist($0) }
    }
    
    public func registerIfNotExist(_ module: ActionsModule.Type) {
        registerIfNotExist(module.actions)
    }
    
    public func unregister(type: String) -> ActionSchema? {
        guard let index = actionsRegistry.firstIndex(where: { $0.type == type }) else { return nil }
        return actionsRegistry.remove(at: index)
    }
}
