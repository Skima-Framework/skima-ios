/*
Skima Framework
Copyright (C) 2022 Joaquin Bozzalla

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

public final class ActionsEngine {
    
    public static let shared = ActionsEngine()
    
    private init() {}
    
    private var actionsRegistry: [ActionSchema] = []
    
    public func getIfExist(type: String?) -> ActionSchema? {
        guard let _type = type else { return nil }
        return actionsRegistry.first { $0.type == _type }
    }
    
    public func registerOrReplace(_ action: ActionSchema) {
        if let index = actionsRegistry.firstIndex(where: { $0.type == action.type }) {
            actionsRegistry[index] = action
        } else {
            actionsRegistry.append(action)
        }
    }
    
    public func registerOrReplace(_ actions: [ActionSchema]) {
        actions.forEach { registerOrReplace($0) }
    }
    
    public func registerOrReplace(_ module: ActionsModule.Type) {
        registerOrReplace(module.actions)
    }
    
    public func registerIfNotExist(_ action: ActionSchema) {
        guard getIfExist(type: action.type) != nil else { return }
        registerOrReplace(action)
    }
    
    public func registerIfNotExist(_ actions: [ActionSchema]) {
        actions.forEach { registerIfNotExist($0) }
    }
    
    public func registerIfNotExist(_ module: ActionsModule.Type) {
        registerIfNotExist(module.actions)
    }
    
    public func unregister(type: String) -> ActionSchema? {
        guard let index = actionsRegistry.firstIndex(where: { $0.type == type }) else { return nil }
        return actionsRegistry.remove(at: index)
    }
}
