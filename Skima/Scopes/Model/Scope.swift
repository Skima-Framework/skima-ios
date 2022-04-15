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

import NanoID

public class Scope {
    let uuid: String
    let key: String
    var elements: [ScopeElement] = []
    
    init(key: String? = nil) {
        uuid = ID().generate()
        self.key = key ?? uuid
    }
    
    func register(_ element: ScopeElement) {
        elements.append(element)
    }
    
    func unregister(_ element: ScopeElement) {
        elements.removeAll { $0.uuid == element.uuid }
        if elements.count == 0 {
            // WARNING: Creo que esto puede generar un ciclo de retencion
            ScopesManager.shared.unregister(self)
        }
    }
}
