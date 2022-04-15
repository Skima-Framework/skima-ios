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

public protocol WidgetPropsType: Decodable {}

public class Widget: ScopeElement, Decodable {
    public let id: String?
    public let scopesIds: [String]?
    public let type: String?
    public let props: WidgetPropsType?
    let constraints: [Constraint]?
    weak var view: UIView?
    
    enum CodingKeys: String, CodingKey {
        case id
        case scopesIds = "scopes"
        case type
        case props
        case constraints
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(String.self, forKey: .id)
        type = try? container?.decode(String.self, forKey: .type)
        constraints = try? container?.decode([Constraint].self, forKey: .constraints)
        scopesIds = try? container?.decode([String].self, forKey: .scopesIds)
        
        guard let widgetSchema = WidgetsEngine.shared.getIfExist(type: type),
              let _container = container
        else {
            props = nil
            super.init()
            return
        }
        props = try? widgetSchema.props.init(from: _container.superDecoder(forKey: .props))
        super.init()
    }
    
}
