//
//  ScopeElement.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 12/04/2022.
//

import NanoID

public class ScopeElement {
    let uuid = ID().generate()
    public var scopes: [Scope] = []
    
    public func isIn(_ scopes: [Scope]?) -> Bool {
        for scope in scopes ?? [] {
            if isIn(scope) {
                return true
            }
        }
        return false
    }
    
    public func isIn(_ scope: Scope?) -> Bool {
        guard let _scope = scope else { return false }
        for eachScope in scopes {
            if eachScope.uuid == _scope.uuid {
                return true
            }
        }
        return false
    }
    
    deinit {
        scopes.forEach{$0.unregister(self)}
    }
}
