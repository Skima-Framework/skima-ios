//
//  TabbarModel.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 12/04/2022.
//

struct Tabbar: Decodable {
    let metadata: TabbarMetadata?
    let keepInStack: Bool?
    let actions: TabbarActions?
    let tabs: [Tabs]?
}

struct TabbarMetadata: Decodable {
    let id: String?
    let version: String?
    let flow: String?
}

struct TabbarActions: Decodable {
    let didLoad: [Action]?
    let willAppear: [Action]?
    let willDisappear: [Action]?
    let back: [Action]?
}

struct Tabs: Decodable {
    let id: String?
    let endpoint: String?
    let title: String?
    let image: String?
}
