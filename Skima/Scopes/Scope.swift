//
//  Scope.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 31/03/2022.
//

import NanoID

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
    
    @discardableResult func register(_ element: ScopeElement, `in` scope: String?) -> Scope {
        element.scope = getOrCreate(withId: scope)
        element.scope?.register(element)
        return element.scope!
    }
    
    func unregister(_ scope: Scope) {
        scopes.removeValue(forKey: scope.key)
    }
}

public class Scope {
    let uuid: String
    let key: String
    var elements: [ScopeElement] = []
    
    init(key: String? = nil) {
        uuid = ID().generate()
        self.key = key ?? uuid
    }
    
    func register(_ element: ScopeElement) {
        elements.append(element)
    }
    
    func unregister(_ element: ScopeElement) {
        elements.removeAll { $0.uuid == element.uuid }
        if elements.count == 0 {
            // WARNING: Creo que esto puede generar un ciclo de retencion
            ScopesManager.shared.unregister(self)
        }
    }
}

public class ScopeElement {
    let uuid = ID().generate()
    public weak var scope: Scope?
    
    deinit {
        scope?.unregister(self)
    }
}
