//
//  Widget.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

public protocol WidgetPropsType: Decodable {}

public class Widget: ScopeElement, Decodable {
    public let id: String?
    public let scopeId: String?
    public let type: String?
    public let props: WidgetPropsType?
    let constraints: [Constraint]?
    weak var view: UIView?
    
    enum CodingKeys: String, CodingKey {
        case id
        case scopeId
        case type
        case props
        case constraints
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(String.self, forKey: .id)
        type = try? container?.decode(String.self, forKey: .type)
        constraints = try? container?.decode([Constraint].self, forKey: .constraints)
        scopeId = try? container?.decode(String.self, forKey: .scopeId)
        
        guard let widgetSchema = WidgetsEngine.shared.getIfExist(type: type),
              let _container = container
        else {
            props = nil
            super.init()
            ScopesManager.shared.register(self, in: scopeId)
            return
        }
        props = try? widgetSchema.props.init(from: _container.superDecoder(forKey: .props))
        super.init()
        if let _scopeId = scopeId {
            ScopesManager.shared.register(self, in: _scopeId)
        }
    }
    
}
