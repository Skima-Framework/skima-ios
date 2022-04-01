//
//  DataEngine.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 22/03/2022.
//

public class VariableModel: ScopeElement, Decodable {
    let id: String?
    let type: String?
    var value: String?
    
    public init(id: String?, scope: Scope?, type: String?, value: String?) {
        self.id = id
        self.type = type
        self.value = value
        super.init()
        ScopesManager.shared.register(self, in: scope?.key)
    }
}

public final class DataEngine {
    
    public static var shared = DataEngine()
    private init() {}
    
    private var data = [String: VariableModel]()
    
    public func createOrModify(_ variable: VariableModel, from scope: Scope?) {
        guard let _scope = scope,
              _scope.uuid == variable.scope?.uuid,
              let dataId = variable.id else { return }
        if let _value = data[dataId] {
            _value.value = variable.value
        } else {
            data[dataId] = variable
        }
    }
    
    public func createIfNotExists(_ variable: VariableModel, from scope: Scope?) {
        guard let dataId = variable.id, data[dataId] == nil else { return }
        data[dataId] = variable
    }
    
    public func modifyIfExists(_ variable: VariableModel, from scope: Scope?) {
        guard let dataId = variable.id, let _data = data[dataId], _data.scope?.uuid == scope?.uuid else { return }
        data[dataId] = variable
    }
    
    public func remove(_ variable: VariableModel, from scope: Scope?) {
        guard let dataId = variable.id, let _data = data[dataId], _data.scope?.uuid == scope?.uuid else { return }
        remove(dataId, from: scope)
    }
    
    public func remove(_ id: String, from scope: Scope?) {
        guard let _scope = scope, let _data = data[id], _data.scope?.uuid == _scope.uuid else { return }
        data.removeValue(forKey: id)
    }
    
    public func getValue(of id: String, from scope: Scope?) -> String? {
        guard let _data = data[id], _data.scope?.uuid == scope?.uuid else { return nil }
        return _data.value
    }
    
}
