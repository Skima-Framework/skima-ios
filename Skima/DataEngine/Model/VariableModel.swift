//
//  VariableModel.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 12/04/2022.
//

public class VariableModel: ScopeElement, Decodable {
    let id: String?
    let type: String?
    var value: String?
    
    public init(id: String?, scopes: [Scope]?, type: String?, value: String?) {
        self.id = id
        self.type = type
        self.value = value
        super.init()
        ScopesManager.shared.register(self, in: scopes)
    }
    
    public init(id: String?, scope: Scope?, type: String?, value: String?) {
        self.id = id
        self.type = type
        self.value = value
        super.init()
        ScopesManager.shared.register(self, in: scope?.key)
    }
}
