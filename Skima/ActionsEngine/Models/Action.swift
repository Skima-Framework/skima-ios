//
//  Action.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

public protocol ActionDataType: Decodable {
    func execute(from scope: Scope?)
}

public class Action: ScopeElement, Decodable {
    let id: String?
    let type: String?
    let data: ActionDataType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case data
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? values?.decode(String.self, forKey: .id)
        type = try? values?.decode(String.self, forKey: .type)
        
        if let actionSchema = ActionsEngine.shared.getIfExist(type: type),
           let container = values {
            data = try? actionSchema.actionData.init(from: container.superDecoder(forKey: .data))
        } else {
            data = nil
        }
        
        super.init()
    }
    
    func execute(from scope: Scope?) {
        data?.execute(from: scope)
    }
}
