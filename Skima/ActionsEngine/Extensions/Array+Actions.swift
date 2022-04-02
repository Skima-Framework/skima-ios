//
//  Array+Actions.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 24/03/2022.
//

public extension Array where Element == Action {
    func execute(from scopes: [Scope]?) {
        forEach { $0.execute(from: scopes) }
    }
    
    func execute(from scope: Scope?) {
        forEach { $0.execute(from: scope) }
    }
}
