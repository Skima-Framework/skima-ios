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

import UIKit
import NanoID
import PureLayout

public final class WidgetsEngine {
    
    public static let shared = WidgetsEngine()
    private init() {}
    
    var widgetsTree = WeakArray<UIView>() // Es solo un array, pensaba hacerlo como arbol de widgets
    
    private var widgetsRegistry: [WidgetSchema] = []
    
    private func getWidgetBy(id: String) -> UIWidget? {
        for widget in widgetsTree {
            if let _widget = widget as? UIWidget,
               _widget.widget.id == id {
                return _widget
            }
        }
        return nil
    }
    
    public func getWidgetBy(id: String, from scopes: [Scope]?) -> UIWidget? {
        for widget in widgetsTree {
            if let _widget = widget as? UIWidget,
               _widget.widget.id == id,
               _widget.widget.isIn(scopes) {
                return _widget
            }
        }
        return nil
    }
    
    public func getWidgetBy(id: String, from scope: Scope?) -> UIWidget? {
        guard let _scope = scope else { return nil }
        return getWidgetBy(id: id, from: [_scope])
    }
    
    public func create(from widget: Widget) -> UIWidget? {
        guard let widgetClass = getIfExist(type: widget.type) else { return nil }
        let newWidget = widgetClass.view.init(from: widget)
        widget.view = newWidget
        return newWidget
    }
    
    public func getIfExist(type: String?) -> WidgetSchema? {
        guard let _type = type else { return nil }
        return widgetsRegistry.first { $0.type == _type }
    }
    
    public func registerOrReplace(_ widget: WidgetSchema) {
        if let index = widgetsRegistry.firstIndex(where: { $0.type == widget.type }) {
            widgetsRegistry[index] = widget
        } else {
            widgetsRegistry.append(widget)
        }
        ActionsEngine.shared.registerOrReplace(widget.view.manipulators)
    }
    
    public func registerOrReplace(_ widgets: [WidgetSchema]) {
        widgets.forEach { registerOrReplace($0) }
    }
    
    public func registerOrReplace(_ module: UIModule.Type) {
        registerOrReplace(module.widgets)
    }
    
    public func registerIfNotExist(_ widget: WidgetSchema) {
        guard getIfExist(type: widget.type) != nil else { return }
        registerOrReplace(widget)
        ActionsEngine.shared.registerOrReplace(widget.view.manipulators)
    }
    
    public func registerIfNotExist(_ widgets: [WidgetSchema]) {
        widgets.forEach { registerIfNotExist($0) }
    }
    
    public func registerIfNotExist(_ module: UIModule.Type) {
        registerIfNotExist(module.widgets)
    }
    
    public func unregister(type: String) -> WidgetSchema? {
        guard let index = widgetsRegistry.firstIndex(where: { $0.type == type }) else { return nil }
        return widgetsRegistry.remove(at: index)
    }
    
    public func render<T>(_ widgets: [Widget]?, `in` view: T, scopes: [Scope]?) {
        let scopesIds = scopes?.map{ return $0.key }
        render(widgets, in: view, scopes: scopesIds ?? [])
    }
    
    public func render<T>(_ widgets: [Widget]?, `in` view: T, scopeId: String?) {
        let newScopeId = scopeId ?? ID().generate()
        render(widgets, in: view, scopes: [newScopeId])
    }
    
    public func render<T>(_ widgets: [Widget]?, `in` view: T, scopes: [String]?) {
        
        let skimaWidgets: [UIWidget] = createAndAddToTree(widgets, scopes: scopes)
        addWidgetsIntoView(skimaWidgets, in: view)
        addConstraintsOf(widgets: skimaWidgets)
    }
    
    private func createAndAddToTree(_ widgets: [Widget]?, scopes: [String]?) -> [UIWidget] {
        var skimaWidgets: [UIWidget] = []
        
        widgets?.forEach { widget in
            var widgetScopes = widget.scopesIds ?? []
            widgetScopes += scopes ?? []
            ScopesManager.shared.register(widget, in: widgetScopes)
            guard let _widget = create(from: widget) else { return }
            skimaWidgets.append(_widget)
            widgetsTree.append(_widget)
        }
        
        return skimaWidgets
    }
    
    private func addWidgetsIntoView<T>(_ widgets: [UIWidget], `in` view: T) {
        widgets.forEach {
            if view is UIStackView {
                (view as? UIStackView)?.addArrangedSubview($0)
            } else if view is UIView {
                (view as? UIView)?.addSubview($0)
            }
        }
    }
    
    private func addConstraintsOf(widgets: [UIWidget]) {
        widgets.forEach { addConstraintOf(widget: $0) }
    }
    
    private func addConstraintOf(widget: UIWidget) {
        widget.widget.constraints?.forEach { skimaConstraint in
            switch skimaConstraint.type {
            case .topEqual, .bottomEqual, .rightEqual, .leftEqual:
                guard let side = mapEqualConstraint(skimaConstraint.type) else { return }
                
                if let toSide = mapSideConstraint(skimaConstraint.to),
                   let ofId = skimaConstraint.of,
                   let ofWidget = getWidgetBy(id: ofId) {
                    widget.autoPinEdge(side, to: toSide, of: ofWidget, withOffset: skimaConstraint.value ?? 0)
                } else {
                    widget.autoPinEdge(toSuperviewSafeArea: side, withInset: skimaConstraint.value ?? 0)
                }
                
            case .height:
                widget.autoSetDimension(.height, toSize: skimaConstraint.value ?? 0)
            case .width:
                widget.autoSetDimension(.width, toSize: skimaConstraint.value ?? 0)
            case .centerX:
                widget.autoAlignAxis(toSuperviewAxis: .vertical)
            case .centerY:
                widget.autoAlignAxis(toSuperviewAxis: .horizontal)
            case .horizontalMargin:
                widget.autoPinEdge(toSuperviewEdge: .left, withInset: skimaConstraint.value ?? 0)
                widget.autoPinEdge(toSuperviewEdge: .right, withInset: skimaConstraint.value ?? 0)
            default:
                return
            }
        }
    }
    
    private func mapEqualConstraint(_ constraint: ConstraintType?) -> ALEdge? {
        switch constraint {
        case .topEqual:
            return .top
        case .bottomEqual:
            return .bottom
        case .rightEqual:
            return .right
        case .leftEqual:
            return .left
        default:
            return nil
        }
    }
    
    private func mapSideConstraint(_ side: ConstraintWidgetSide?) -> ALEdge? {
        switch side {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .right:
            return .right
        case .left:
            return .left
        default:
            return nil
        }
    }
}
