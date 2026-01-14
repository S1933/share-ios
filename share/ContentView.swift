//
//  ContentView.swift
//  share
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedLink.timestamp, order: .reverse) private var links: [SavedLink]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(links) { link in
                    NavigationLink {
                        VStack(spacing: 20) {
                            Text(link.title ?? "No Title")
                                .font(.title)
                            
                            Link(link.url.absoluteString, destination: link.url)
                                .buttonStyle(.borderedProminent)
                            
                            if !link.tags.isEmpty {
                                HStack {
                                    ForEach(link.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.secondary.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(link.title ?? "Unknown Title")
                                .font(.headline)
                                .lineLimit(1)
                            Text(link.url.host() ?? link.url.absoluteString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Link", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Saved Links")
        } detail: {
            Text("Select a link")
        }
    }

    private func addItem() {
        withAnimation {
            let newLink = SavedLink(url: URL(string: "https://apple.com")!, title: "Apple")
            modelContext.insert(newLink)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(links[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SavedLink.self, inMemory: true)
}
