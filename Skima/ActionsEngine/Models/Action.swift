//
//  Action.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

public protocol ActionDataType: Decodable {
    func execute(from scopes: [Scope]?)
}

public class Action: ScopeElement, Decodable {
    let id: String?
    let type: String?
    let data: ActionDataType?
    let scopesIds: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case data
        case scopesIds = "scopes"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? values?.decode(String.self, forKey: .id)
        type = try? values?.decode(String.self, forKey: .type)
        scopesIds = try? values?.decode([String].self, forKey: .scopesIds)
        
        if let actionSchema = ActionsEngine.shared.getIfExist(type: type),
           let container = values {
            data = try? actionSchema.actionData.init(from: container.superDecoder(forKey: .data))
        } else {
            data = nil
        }
        
        super.init()
    }
    
    func execute(from scopes: [Scope]?) {
        var ownScopes = scopesIds?.map({ id in
            return ScopesManager.shared.getOrCreate(withId: id)
        })
        ownScopes = (ownScopes ?? []) + (scopes ?? [])
        data?.execute(from: ownScopes)
    }
    
    func execute(from scope: Scope?) {
        if let _scope = scope {
            execute(from: [_scope])
        }
    }
}
