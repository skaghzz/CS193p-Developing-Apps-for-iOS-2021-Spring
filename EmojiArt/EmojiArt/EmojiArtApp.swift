//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by 60080341 on 2021/11/18.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
