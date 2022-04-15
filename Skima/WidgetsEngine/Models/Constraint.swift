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
