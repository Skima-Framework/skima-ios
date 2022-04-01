//
//  ScreenModel.swift
//  Skima
//
//  Created by Joaquin Bozzalla on 17/03/2022.
//

struct Screen: Decodable {
    let metadata: ScreenMetadata?
    let keepInStack: Bool?
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
