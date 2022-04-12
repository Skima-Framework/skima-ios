//
//  WeakUtils.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 12/04/2022.
//

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
