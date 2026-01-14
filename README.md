# Share - Link Saver

A simple, native iOS and macOS application designed to save and organize links efficiently. Built with modern Swift technologies, it leverages a Share Extension for seamless integration with the system and uses Natural Language processing to automatically categorize your saved content.

## Features

- **Save Links:** Quickly store URLs from Safari or any other app.
- **Share Extension:** Integrated directly into the iOS/macOS Share Sheet for one-tap saving.
- **Automatic Metadata:** Automatically fetches web page titles.
- **Smart Tagging:** Uses Apple's `NaturalLanguage` framework to analyze content and suggest relevant tags automatically.
- **Modern Tech Stack:** Built with **SwiftUI** and **SwiftData** for robust and reactive performance.
- **Cross-Platform:** Supports both iOS and macOS.

## Requirements

- iOS 17.0+ / macOS 14.0+
- Xcode 15.0+ (SwiftData support required)

## Setup & Configuration

To build and run this project, you need to configure **App Groups** to allow the main app and the Share Extension to share the SwiftData database.

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd share
   ```

2. **Open the project:**
   Open `share.xcodeproj` in Xcode.

3. **Configure App Groups:**
   The app uses a shared container to persist data between the main app and the extension.
   - **Main App Target (`share`):**
     - Go to **Signing & Capabilities**.
     - Click **+ Capability** and add **App Groups**.
     - Add a new group named: `group.s1933.share.data`.
     - Ensure it is checked.
   - **Extension Target (`ShareExtension`):**
     - Go to **Signing & Capabilities**.
     - Add **App Groups** (if not present).
     - Select the **same** group: `group.s1933.share.data`.

4. **Verify Bundle Identifiers:**
   Ensure the Bundle Identifiers for both targets are unique and signed with your Apple Developer account.

5. **Build and Run:**
   - Select the `share` scheme and run on a Simulator or Device.

## Project Structure

- **`share/`**: Contains the main application code.
    - `shareApp.swift`: App entry point and `ModelContainer` setup.
    - `ContentView.swift`: Main UI for listing and managing saved links.
    - `SavedLink.swift`: SwiftData model definition.
    - `LinkMetadataService.swift`: Logic for fetching URL titles and generating tags.
- **`ShareExtension/`**: Contains the Share Extension code.
    - `ShareViewController.swift`: Handles the incoming share request and data saving.
    - `ShareView.swift`: SwiftUI view presented within the extension.

## Technologies Used

- **SwiftUI**: Declarative UI framework.
- **SwiftData**: Persistence framework for managing the database.
- **NaturalLanguage**: Framework for analyzing text to generate tags.
- **App Groups**: For sharing data between the app and its extension.
