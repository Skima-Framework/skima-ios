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

class ScopesManager {
    static let shared = ScopesManager()
    private init() {}
    
    var scopes = [String: Scope]()
    
    func registerScope(_ scope: Scope) -> Bool {
        guard scopes[scope.uuid] == nil else { return false }
        scopes[scope.uuid] = scope
        return true
    }
    
    func getOrCreate(withId: String?) -> Scope {
        if let id = withId, let found = scopes[id] {
            return found
        }
        
        let newScope = Scope(key: withId)
        scopes[newScope.key] = newScope
        return newScope
    }
    
    func register(_ element: ScopeElement, `in` scopes: [Scope]?) {
        scopes?.forEach{ register(element, in: $0.key) }
    }
    
    func register(_ element: ScopeElement, `in` scopes: [String]) {
        scopes.forEach{ register(element, in: $0) }
    }
    
    func register(_ element: ScopeElement, `in` scope: String?) {
        let newScope = getOrCreate(withId: scope)
        element.scopes.append(newScope)
        newScope.register(element)
    }
    
    func unregister(_ scope: Scope) {
        scopes.removeValue(forKey: scope.key)
    }
}




