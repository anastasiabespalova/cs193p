//
//  ContentView.swift
//  EmojiArt
//
//  Created by Анастасия Беспалова on 23.07.2021.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    let defaultEmojiFontSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            HStack {
                Spacer()
                palette
                Spacer()
                deleteButton
                Spacer()
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
                .gesture(doubleTapToZoom(in: geometry.size))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                .border(isEmojiSelected(for: emoji) ? Color.green : Color.clear)
                                .font(.system(size: fontSize(for: emoji)))
                                .scaleEffect(zoomScale(for: emoji))
                                .position(position(for: emoji, in: geometry))
                                .gesture(panGestureEmoji(for: emoji).simultaneously(with: tapToSelectEmoji(emoji)))
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) { providers, location in
                drop(providers: providers, at: location, in: geometry)
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
            .gesture(tapToFlushEmoji())
            
        }
    }
    
    var deleteButton: some View {
        Button(action:  { withAnimation(){
            document.deleteSelectedEmojis(selectedEmojis)
        }
            
        } , label: {
            VStack {
                Image(systemName: "trash")
                Text("Delete")
            }
        })
    }
    
    
    
    private func drop(providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) {url in
            document.setBackground(EmojiArtModel.Background.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) {image in
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
    
    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
    
        if isEmojiSelected(for: emoji) && gesturePanOffsetEmoji.isSingle == false {
            return convertFromEmojiCoordinates((emoji.x + Int(gesturePanOffsetEmoji.panOffset.width), emoji.y + Int(gesturePanOffsetEmoji.panOffset.height)), in: geometry)
        } else if (gesturePanOffsetEmoji.isSingle && gesturePanOffsetEmoji.emoji != nil && gesturePanOffsetEmoji.emoji!.id == emoji.id) {
            return convertFromEmojiCoordinates((emoji.x + Int(gesturePanOffsetEmoji.panOffset.width), emoji.y + Int(gesturePanOffsetEmoji.panOffset.height)), in: geometry)
        } else {
            return convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
            }
    }
    
    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint (
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
    
    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }
    
// MARK: -CommonPan
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
    
   // @GestureState private var gesturePanOffsetEmoji: CGSize = CGSize.zero
    @GestureState private var gesturePanOffsetEmoji = DragSingleEmoji(panOffset: CGSize.zero, isSingle: false, emoji: nil)
    
    struct DragSingleEmoji {
        var panOffset: CGSize
        var isSingle: Bool
        var emoji: EmojiArtModel.Emoji?
    }
    
    
    private func panGestureEmoji(for emoji: EmojiArtModel.Emoji) -> some Gesture {
        return DragGesture()
            .updating($gesturePanOffsetEmoji) { latestDragGestureValue, gesturePanOffsetEmoji, _ in
                //gesturePanOffsetEmoji = latestDragGestureValue.translation / zoomScale
                gesturePanOffsetEmoji.panOffset = latestDragGestureValue.translation / zoomScale
                gesturePanOffsetEmoji.isSingle = isEmojiSelected(for: emoji) ? false : true
                gesturePanOffsetEmoji.emoji = isEmojiSelected(for: emoji) ? nil : emoji
                
            }
            .onEnded { finalDragGestureValue in
                if isEmojiSelected(for: emoji) {
                    for emoji in selectedEmojis {
                        document.moveEmoji(emoji, by: finalDragGestureValue.translation / zoomScale)
                    }
                } else {
                    document.moveEmoji(emoji, by: finalDragGestureValue.translation / zoomScale)
                }

                
            }
    }
    
    
// MARK: -CommonZoom
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * (selectedEmojis.isEmpty ? gestureZoomScale : 1)
    }
    
    private func zoomScale(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        if isEmojiSelected(for: emoji) {
            return steadyStateZoomScale * gestureZoomScale
        } else {
            return zoomScale
        }
    }
    
    private func zoomGesture() -> some Gesture{
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                if selectedEmojis.isEmpty {
                    steadyStateZoomScale *= gestureScaleAtEnd
                } else {
                    selectedEmojis.forEach { emoji in
                        document.scaleEmoji(emoji, by: gestureScaleAtEnd)
                            
                    }
                }
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
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize){
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
   
    
// MARK: -Palette
    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiFontSize))
    }
    
    
    let testEmojis = "🐎🐄🦒🦘🦏🐜🐔🦣🎋🌿🌜"
    
    @State private var selectedEmojis = Array<EmojiArtModel.Emoji>()
    
    private func toggleMatching(_ emoji: EmojiArtModel.Emoji) {
        if let index = selectedEmojis.firstIndex(where: {$0.id == emoji.id}) {
                selectedEmojis.remove(at: index)
        } else {
            selectedEmojis.append(emoji)
        }
    }
    
    private func tapToSelectEmoji(_ emoji: EmojiArtModel.Emoji) -> some Gesture {
        TapGesture (count: 1)
            .onEnded {
                withAnimation {
                    selectEmoji(of: emoji)
                }
            }
    }

    private func selectEmoji(of emoji: EmojiArtModel.Emoji) {
        toggleMatching(emoji)
        print(selectedEmojis)
    }
    
    private func tapToFlushEmoji() -> some Gesture {
        TapGesture (count: 1)
            .onEnded {
                withAnimation {
                    flushSelectedEmojis()
                }
            }
    }
    
    private func flushSelectedEmojis() {
        selectedEmojis.removeAll()
        print(selectedEmojis)
    }
    
    private func isEmojiSelected(for emoji:  EmojiArtModel.Emoji) -> Bool {
        return ((selectedEmojis.firstIndex(where: {$0.id == emoji.id})) != nil)
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    
    var body: some View {
        
        ScrollView(.horizontal){
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
