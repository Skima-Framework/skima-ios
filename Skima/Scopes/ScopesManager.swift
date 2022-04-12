//
//  ScopesManager.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 31/03/2022.
//

class ScopesManager {
    static let shared = ScopesManager()
    private init() {}
    
    var scopes = [String: Scope]()
    
    func registerScope(_ scope: Scope) -> Bool {
        guard scopes[scope.uuid] == nil else { return false }
        scopes[scope.uuid] = scope
        return true
    }
    
    func getOrCreate(withId: String?) -> Scope {
        if let id = withId, let found = scopes[id] {
            return found
        }
        
        let newScope = Scope(key: withId)
        scopes[newScope.key] = newScope
        return newScope
    }
    
    func register(_ element: ScopeElement, `in` scopes: [Scope]?) {
        scopes?.forEach{ register(element, in: $0.key) }
    }
    
    func register(_ element: ScopeElement, `in` scopes: [String]) {
        scopes.forEach{ register(element, in: $0) }
    }
    
    func register(_ element: ScopeElement, `in` scope: String?) {
        let newScope = getOrCreate(withId: scope)
        element.scopes.append(newScope)
        newScope.register(element)
    }
    
    func unregister(_ scope: Scope) {
        scopes.removeValue(forKey: scope.key)
    }
}




