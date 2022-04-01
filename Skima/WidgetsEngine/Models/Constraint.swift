//
//  Constraint.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 24/03/2022.
//

struct Constraint: Decodable {
    let id: String?
    let type: ConstraintType?
    let to: ConstraintWidgetSide?
    let of: String?
    let value: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, type, to, of, value
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(String.self, forKey: .id)
        type = try? container?.decode(ConstraintType.self, forKey: .type)
        to = try? container?.decode(ConstraintWidgetSide.self, forKey: .to)
        of = try? container?.decode(String.self, forKey: .of)
        value = try? container?.decode(Double.self, forKey: .value)
    }
}

enum ConstraintType: String, Decodable {
    case topEqual
    case bottomEqual
    case rightEqual
    case leftEqual
    case height
    case width
    case centerX
    case centerY
    case horizontalMargin
}

enum ConstraintWidgetSide: String, Decodable {
    case top
    case bottom
    case left
    case right
}
