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

struct Screen: Decodable {
    let metadata: ScreenMetadata?
    let keepInStack: Bool?
    let backgroundColor: String?
    let actions: ScreenActions?
    let ui: [Widget]?
}

struct ScreenMetadata: Decodable {
    let id: String?
    let version: String?
    let flow: String?
}

struct ScreenActions: Decodable {
    let didLoad: [Action]?
    let willAppear: [Action]?
    let willDisappear: [Action]?
    let back: [Action]?
}
