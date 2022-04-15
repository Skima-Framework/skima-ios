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

public class ScopeElement {
    let uuid = ID().generate()
    public var scopes: [Scope] = []
    
    public func isIn(_ scopes: [Scope]?) -> Bool {
        for scope in scopes ?? [] {
            if isIn(scope) {
                return true
            }
        }
        return false
    }
    
    public func isIn(_ scope: Scope?) -> Bool {
        guard let _scope = scope else { return false }
        for eachScope in scopes {
            if eachScope.uuid == _scope.uuid {
                return true
            }
        }
        return false
    }
    
    deinit {
        scopes.forEach{$0.unregister(self)}
    }
}
