//
//  WidgetsEngine.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

import UIKit
import NanoID
import PureLayout

final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}

struct WeakArray<Element: AnyObject> {
    private var items: [WeakBox<Element>] = []
    init(_ elements: [Element]? = nil) {
        items = elements?.map { WeakBox($0) } ?? []
    }
    
    mutating func append(_ item: Element) {
        items.append(WeakBox(item))
    }
}

extension WeakArray: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex: Int { return items.endIndex }
    
    subscript(_ index: Int) -> Element? {
        return items[index].unbox
    }
    
    func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
}

public final class WidgetsEngine {
    
    public static let shared = WidgetsEngine()
    
    private init() {}
    
    var widgetsTree = WeakArray<UIView>()
    
    private var widgetsRegistry: [WidgetSchema] = []
    
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
    
    public func render(_ widgets: [Widget]?, `in` view: UIView, scopeId: String?) {
        var schemappWidgets: [UIWidget] = []
        let newId = scopeId ?? ID().generate()
        
        widgets?.forEach { widget in
            var scopes = widget.scopesIds ?? []
            scopes.append(newId)
            ScopesManager.shared.register(widget, in: scopes)
            guard let _widget = create(from: widget) else { return }
            schemappWidgets.append(_widget)
            widgetsTree.append(_widget)
        }
        
        schemappWidgets.forEach { view.addSubview($0) }
        
        schemappWidgets.forEach { schemappWidget in
            schemappWidget.widget.constraints?.forEach { schemappConstraint in
                switch schemappConstraint.type {
                case .topEqual, .bottomEqual, .rightEqual, .leftEqual:
                    guard let side = mapEqualConstraint(schemappConstraint.type) else { return }
                    
                    if let toSide = mapSideConstraint(schemappConstraint.to),
                       let ofId = schemappConstraint.of,
                       let ofWidget = schemappWidgets.first(where: { $0.widget.id == ofId }) {
                        schemappWidget.autoPinEdge(side, to: toSide, of: ofWidget, withOffset: schemappConstraint.value ?? 0)
                    } else {
                        schemappWidget.autoPinEdge(toSuperviewSafeArea: side, withInset: schemappConstraint.value ?? 0)
                    }
                    
                case .height:
                    schemappWidget.autoSetDimension(.height, toSize: schemappConstraint.value ?? 0)
                case .width:
                    schemappWidget.autoSetDimension(.width, toSize: schemappConstraint.value ?? 0)
                case .centerX:
                    schemappWidget.autoAlignAxis(toSuperviewAxis: .vertical)
                case .centerY:
                    schemappWidget.autoAlignAxis(toSuperviewAxis: .horizontal)
                case .horizontalMargin:
                    schemappWidget.autoPinEdge(toSuperviewEdge: .left, withInset: schemappConstraint.value ?? 0)
                    schemappWidget.autoPinEdge(toSuperviewEdge: .right, withInset: schemappConstraint.value ?? 0)
                default:
                    return
                }
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
