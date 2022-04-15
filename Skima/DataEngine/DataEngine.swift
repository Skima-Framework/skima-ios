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

public final class DataEngine {
    
    public static var shared = DataEngine()
    private init() {}
    
    private var data = [String: VariableModel]()
    
    public func createOrModify(_ variable: VariableModel, from scopes: [Scope]?) {
        guard variable.isIn(scopes), let dataId = variable.id else { return }
        if let _value = data[dataId] {
            _value.value = variable.value
        } else {
            data[dataId] = variable
        }
    }
    
    public func createOrModify(_ variable: VariableModel, from scope: Scope?) {
        guard let _scope = scope else { return }
        createOrModify(variable, from: [_scope])
    }
    
    public func createIfNotExists(_ variable: VariableModel, from scopes: [Scope]?) {
        guard let dataId = variable.id, data[dataId] == nil else { return }
        data[dataId] = variable
    }
    
    public func createIfNotExists(_ variable: VariableModel, from scope: Scope?) {
        guard let _scope = scope else { return }
        createIfNotExists(variable, from: [_scope])
    }
    
    public func modifyIfExists(_ variable: VariableModel, from scopes: [Scope]?) {
        guard let dataId = variable.id, let _data = data[dataId], _data.isIn(scopes) else { return }
        data[dataId] = variable
    }
    
    public func modifyIfExists(_ variable: VariableModel, from scope: Scope?) {
        guard let _scope = scope else { return }
        modifyIfExists(variable, from: [_scope])
    }
    
    public func remove(_ variable: VariableModel, from scopes: [Scope]?) {
        guard let dataId = variable.id, let _data = data[dataId], _data.isIn(scopes) else { return }
        remove(dataId, from: scopes)
    }
    
    public func remove(_ variable: VariableModel, from scope: Scope?) {
        guard let _scope = scope else { return }
        remove(variable, from: [_scope])
    }
    
    public func remove(_ id: String, from scopes: [Scope]?) {
        guard let _data = data[id], _data.isIn(scopes) else { return }
        data.removeValue(forKey: id)
    }
    
    public func remove(_ id: String, from scope: Scope?) {
        guard let _scope = scope else { return }
        remove(id, from: [_scope])
    }
    
    public func getValue(of id: String, from scopes: [Scope]?) -> String? {
        guard let _data = data[id], _data.isIn(scopes) else { return nil }
        return _data.value
    }
    
    public func getValue(of id: String, from scope: Scope?) -> String? {
        guard let _scope = scope else { return nil }
        return getValue(of: id, from: [_scope])
    }
    
}
