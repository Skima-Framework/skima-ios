/**
*  Skima Framework
*  Copyright (C) 2022 Joaquin Bozzalla
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU Affero General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU Affero General Public License for more details.
*
*  You should have received a copy of the GNU Affero General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
        var ownScopes = scopesIds?.map { ScopesManager.shared.getOrCreate(withId: $0) }
        ownScopes = (ownScopes ?? []) + (scopes ?? [])
        data?.execute(from: ownScopes)
    }
    
    func execute(from scope: Scope?) {
        if let _scope = scope {
            execute(from: [_scope])
        }
    }
}
