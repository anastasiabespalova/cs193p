//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 29.07.2021.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: ThemeForEmojis
    
    var body: some View {
        Form {
            nameSection
            removeEmojiSection
            addEmojisSection
            cardCountSection
            colorSection
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Theme name")) {
            TextField("Name", text: $theme.name)
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Emojis"), footer: Text("Tap emoji to exclude")) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }

    @State private var emojisToAdd = ""
    var addEmojisSection: some View {
        Section(header: Text("Add emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
        
    }
    
    var cardCountSection: some View {
        Section(header: Text("Card count")) {
            VStack {
                Stepper("\(theme.numberOfPairs) Pairs", value: $theme.numberOfPairs)
            }.padding()
        }
    }
    
    var colorSection: some View {
        Section(header: Text("Color")) {
            Text("Select colors")
        }
    }
    
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 4)))
            //.previewLayout(.fixed(width: 300.0, height: 350.0))
    }
}
