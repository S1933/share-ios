//
//  ShareView.swift
//  ShareExtension
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import SwiftUI
import SwiftData

struct ShareView: View {
    var url: URL
    var onDismiss: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @State private var status: Status = .loading
    @State private var detectedTitle: String?
    @State private var detectedTags: [String] = []
    
    enum Status {
        case loading
        case success
        case error(String)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if case .loading = status {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Analyzing Link...")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else if case .success = status {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                    .transition(.scale)
                
                Text("Saved!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let title = detectedTitle {
                    Text(title)
                        .font(.body)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                HStack {
                    ForEach(detectedTags.prefix(3), id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .padding(6)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .task {
            await saveLink()
        }
    }
    
    private func saveLink() async {
        let (title, tags) = await LinkMetadataService.fetchMetadata(for: url)
        
        await MainActor.run {
            self.detectedTitle = title
            self.detectedTags = tags
            
            let newLink = SavedLink(url: url, title: title, tags: tags)
            modelContext.insert(newLink)
            
            withAnimation {
                self.status = .success
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onDismiss()
            }
        }
    }
}
