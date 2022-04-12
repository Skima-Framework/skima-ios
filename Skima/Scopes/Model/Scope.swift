//
//  Scope.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 12/04/2022.
//

import NanoID

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
