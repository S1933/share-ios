//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import UIKit
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Extract URL from the extension context
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else { return }
        
        for item in extensionItems {
            if let attachments = item.attachments {
                for provider in attachments {
                    if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                            if let url = item as? URL {
                                self?.presentShareView(with: url)
                            } else if let urlString = item as? String, let url = URL(string: urlString) {
                                self?.presentShareView(with: url)
                            }
                        }
                        return
                    }
                }
            }
        }
    }
    
    private func presentShareView(with url: URL) {
        DispatchQueue.main.async {
            // Create the SwiftUI view for the extension
            let rootView = ShareView(url: url) { [weak self] in
                self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            }
            
            // Setup ModelContainer for the extension (MUST match the main app's App Group)
            let schema = Schema([SavedLink.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                groupContainer: .identifier("group.s1933.share.data")
            )
            
            do {
                let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
                let hostingController = UIHostingController(rootView: rootView.modelContainer(container))
                
                self.addChild(hostingController)
                self.view.addSubview(hostingController.view)
                hostingController.view.frame = self.view.bounds
                hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                hostingController.didMove(toParent: self)
            } catch {
                print("Failed to create ModelContainer in Extension: \(error)")
                self.extensionContext?.cancelRequest(withError: error)
            }
        }
    }
}
