//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by Анастасия Беспалова on 29.07.2021.
//

import SwiftUI

struct ThemeManagerView: View {
    @EnvironmentObject var store: ThemeStore
   // var store: ThemeStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
   // @Environment(\.presentationMode) var presentationMode
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                Text("Memorize")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                ForEach(store.themes) { theme in
                    
                    NavigationLink(destination: ThemeEditor(theme: $store.themes[theme])) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .foregroundColor(Color(rgbaColor: theme.color))
                            Text(getText(areAllUsed: (theme.numberOfPairs == theme.emojis.count), numberOfPairs: theme.numberOfPairs) + theme.emojis)
                                .font(.footnote)
                        }
                                
                        // tapping when NOT in editMode will follow the NavigationLink
                        // (that's why gesture is set to nil in that case)
                        .gesture(editMode == .active ? tap : nil)
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in indexSet to a newOffset in its array
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    addThemeButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }

            }

            .environment(\.editMode, $editMode)
        }
    }
    
    func getText(areAllUsed: Bool, numberOfPairs: Int) -> String {
        return areAllUsed ? "All of" : "\(numberOfPairs) pairs from"
    }
    
    var tap: some Gesture {
        TapGesture().onEnded { }
    }
    
    var addThemeButton: some View {
           Button {
               withAnimation {
                    
               }
               
           } label: {
               Image(systemName: "plus")
           }
       }
    
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManagerView()
    }
}
