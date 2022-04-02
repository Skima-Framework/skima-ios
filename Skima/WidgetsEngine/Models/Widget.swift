//
//  Widget.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

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
