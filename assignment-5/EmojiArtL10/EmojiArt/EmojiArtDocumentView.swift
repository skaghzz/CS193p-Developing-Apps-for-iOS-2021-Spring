//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 4/26/21.
//  Copyright © 2021 Stanford University. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            HStack {
                if chosenEmojis.count > 0 {
                    trash
                }
                palette
            }
        }
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0,0), in: geometry))
                )
                    .gesture(doubleTapToZoom(in: geometry.size).exclusively(before: tapToDischoose()))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        ZStack {
                            Text(emoji.text)
                                .font(.system(size: fontSize(for: emoji)))
                                .border(isChosen(emoji) ? Color.black : Color.red)
                                .scaleEffect(zoomScale)
                                .position(position(for: emoji, in: geometry))
                                .gesture(tapToChoose(emoji))
                        }
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            //.gesture(panGesture().simultaneously(with: zoomGesture()))
            .gesture(chosenEmojis.count == 0 ? panGesture().simultaneously(with: zoomGesture()) : nil)
            .gesture(chosenEmojis.count > 0 ? panGestureOfEmoji().simultaneously(with: zoomGestureOfEmoji()) : nil)
        }
    }
    
    // MARK: - Emoji Select and Diselect
    @State private var chosenEmojis: Set<EmojiArtModel.Emoji> = []
    
    private func tapToChoose(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture()
            .onEnded {
                chosenEmojis.toggleMembership(of: emoji)
            }
    }
    
    private func tapToDischoose() -> some Gesture {
        TapGesture()
            .onEnded {
                chosenEmojis.removeAll()
            }
    }
    
    private func isChosen(_ emoji: EmojiArtModel.Emoji) -> Bool {
        chosenEmojis.contains(where: {$0.id == emoji.id})
    }

    // MARK: - Emoji panning
    
    @GestureState private var gesturePanOffsetOfEmoji: CGSize = CGSize.zero
    
    private func panGestureOfEmoji() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffsetOfEmoji) { latestDragGestureValue, gesturePanOffsetOfEmoji, _ in
                moveChosenEmojis(by: latestDragGestureValue.translation / zoomScale - gesturePanOffsetOfEmoji)
                gesturePanOffsetOfEmoji = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                moveChosenEmojis(by: (gesturePanOffsetOfEmoji / zoomScale))
            }
    }
    
    private func moveChosenEmojis(by offset: CGSize) {
        chosenEmojis.forEach { emoji in
            document.moveEmoji(emoji, by: offset)
        }
    }
    
    // MARK: - Emoji Zoom
        
    @GestureState private var gestureZoomScaleOfEmoji: CGFloat = 1
    
    private var zoomScaleOfEmoji: CGFloat {
        gestureZoomScaleOfEmoji
    }
    
    private func zoomGestureOfEmoji() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScaleOfEmoji) { latestGestureScale, gestureZoomScaleOfEmoji, _ in
                gestureZoomScaleOfEmoji = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                scaleChosenEmojis(by: gestureScaleAtEnd)
            }
    }
    
    private func scaleChosenEmojis(by scale: CGFloat) {
        chosenEmojis.forEach { emoji in
            document.scaleEmoji(emoji, by: scale)
        }
    }
    
    // MARK: - Drag and Drop
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackground(.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackground(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )
                }
            }
        }
        return found
    }
    
    // MARK: - Positioning/Sizing Emoji
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size) * (isChosen(emoji) ? zoomScaleOfEmoji : 1)
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }
    
    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    // MARK: - Trash
    var trash: some View {
        AnimatedActionButton(systemImage: "trash") {
            chosenEmojis.forEach { emoji in
                chosenEmojis.remove(emoji)
                document.removeEmoji(emoji)
            }
        }
        .font(.system(size: defaultEmojiFontSize))
    }

    // MARK: - Palette
    
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    let testEmojis = "😀😷🦠💉👻👀🐶🌲🌎🌞🔥🍎⚽️🚗🚓🚲🛩🚁🚀🛸🏠⌚️🎁🗝🔐❤️⛔️❌❓✅⚠️🎶➕➖🏳️"
}



struct ScrollingEmojisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
