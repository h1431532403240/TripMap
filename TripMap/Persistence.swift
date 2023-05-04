//
//  Persistence.swift
//  TripMap
//
//  Created by 廖家慶 on 2022/1/19.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let site = Site(context: viewContext)
        site.coverImage = (UIImage(named: "Cat")?.jpegData(compressionQuality: 1.0))!
        site.time = Date()
        site.star = 3
        site.name = "貓咪餐廳"
        site.id = UUID().uuidString
        site.address = "台南市永康區南台街1號"
        site.hackMDUrl = "https://hackmd.io/@MvQ4L8zNSNqT07komVcx3A/HyKQ6Gl4h"
        site.latitude = 23.0222115138
        site.longitude = 120.224012996
        site.content = """
        # MarkdownUI
        [![CI](https://github.com/gonzalezreal/MarkdownUI/workflows/CI/badge.svg)](https://github.com/gonzalezreal/MarkdownUI/actions?query=workflow%3ACI)
        [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2Fswift-markdown-ui%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui)
        [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2Fswift-markdown-ui%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui)

        Display and customize Markdown text in SwiftUI.

        * [Overview](#overview)
        * [Minimum requirements](#minimum-requirements)
        * [Getting started](#getting-started)
          * [Creating a Markdown view](#creating-a-markdown-view)
          * [Styling Markdown](#styling-markdown)
        * [Documentation](#documentation)
        * [Demo](#demo)
        * [Installation](#installation)

        ## Overview

        MarkdownUI is a powerful library for displaying and customizing Markdown text in SwiftUI. It is
        compatible with the [GitHub Flavored Markdown Spec](https://github.github.com/gfm/) and can
        display images, headings, lists (including task lists), blockquotes, code blocks, tables,
        and thematic breaks, besides styled text and links.

        MarkdownUI offers comprehensible theming features to customize how it displays Markdown text.
        You can use the built-in themes, create your own or override specific text and block styles.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownUI@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownUI~dark@2x.png#gh-dark-mode-only)

        ## Minimum requirements

        You can use MarkdownUI on the following platforms:

        - macOS 12.0+
        - iOS 15.0+
        - tvOS 15.0+
        - watchOS 8.0+

        Some features, like displaying tables or multi-image paragraphs, require macOS 13.0+, iOS 16.0+,
        tvOS 16.0+, and watchOS 9.0+.

        ## Getting started

        ### Creating a Markdown view

        A `Markdown` view displays rich structured text using the Markdown syntax. It can display images,
        headings, lists (including task lists), blockquotes, code blocks, tables, and thematic breaks,
        besides styled text and links.

        The simplest way of creating a `Markdown` view is to pass a Markdown string to the
        `init(_:baseURL:imageBaseURL:)` initializer.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownString@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownString~dark@2x.png#gh-dark-mode-only)

        A more convenient way to create a `Markdown` view is by using the
        `init(baseURL:imageBaseURL:content:)` initializer, which takes a Markdown content
        builder in which you can compose the view content, either by providing Markdown strings or by
        using an expressive domain-specific language.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownContentBuilder@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/MarkdownContentBuilder~dark@2x.png#gh-dark-mode-only)

        You can also create a `MarkdownContent` value in your model layer and later create a `Markdown`
        view by passing the content value to the `init(_:baseURL:imageBaseURL:)` initializer. The
        `MarkdownContent` value pre-parses the Markdown string preventing the view from doing this step.

        ```swift
        // Somewhere in the model layer
        let content = MarkdownContent("You can try **CommonMark** [here](https://spec.commonmark.org/dingus/).")

        // Later in the view layer
        var body: some View {
          Markdown(self.model.content)
        }
        ```

        ### Styling Markdown

        Markdown views use a basic default theme to display the contents. For more information, read about
        the `basic` theme.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/BlockquoteContent@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/BlockquoteContent~dark@2x.png#gh-dark-mode-only)

        You can customize the appearance of Markdown content by applying different themes using the
        `markdownTheme(_:)` modifier. For example, you can apply one of the built-in themes, like
        `gitHub`, to either a Markdown view or a view hierarchy that contains Markdown views.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/GitHubBlockquote@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/GitHubBlockquote~dark@2x.png#gh-dark-mode-only)

        To override a specific text style from the current theme, use the `markdownTextStyle(_:textStyle:)`
        modifier. The following example shows how to override the `code` text style.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/CustomInlineCode@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/CustomInlineCode~dark@2x.png#gh-dark-mode-only)

        You can also use the `markdownBlockStyle(_:body:)` modifier to override a specific block style. For
        example, you can override only the `blockquote` block style, leaving other block styles untouched.

        ![](Sources/MarkdownUI/Documentation.docc/Resources/CustomBlockquote@2x.png#gh-light-mode-only)
        ![](Sources/MarkdownUI/Documentation.docc/Resources/CustomBlockquote~dark@2x.png#gh-dark-mode-only)

        Another way to customize the appearance of Markdown content is to create your own theme. To create
        a theme, start by instantiating an empty `Theme` and chain together the different text and block
        styles in a single expression.

        ```swift
        extension Theme {
          static let fancy = Theme()
            .code {
              FontFamilyVariant(.monospaced)
              FontSize(.em(0.85))
            }
            .link {
              ForegroundColor(.purple)
            }
            // More text styles...
            .paragraph { configuration in
              configuration.label
                .relativeLineSpacing(.em(0.25))
                .markdownMargin(top: 0, bottom: 16)
            }
            .listItem { configuration in
              configuration.label
                .markdownMargin(top: .em(0.25))
            }
            // More block styles...
        }
        ```

        ## Documentation

        [Swift Package Index](https://swiftpackageindex.com) kindly hosts the online documentation for all versions, available here:

        - [main](https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui/main/documentation/markdownui)
        - [2.1.0](https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui/2.1.0/documentation/markdownui)
        - [2.0.2](https://swiftpackageindex.com/gonzalezreal/swift-markdown-ui/2.0.2/documentation/markdownui)

        ## Demo

        MarkdownUI comes with a few more tricks on the sleeve. You can explore the
        [companion demo project](Examples/Demo/) and discover its complete set of capabilities.

        ![](Examples/Demo/Screenshot.png#gh-light-mode-only)
        ![](Examples/Demo/Screenshot~dark.png#gh-dark-mode-only)

        ## Installation
        ### Adding MarkdownUI to a Swift package

        To use MarkdownUI in a Swift Package Manager project, add the following line to the dependencies in your `Package.swift` file:

        ```swift
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.2")
        ```

        Include `"MarkdownUI"` as a dependency for your executable target:

        ```swift
        .target(name: "<target>", dependencies: [
          .product(name: "MarkdownUI", package: "swift-markdown-ui")
        ]),
        ```

        Finally, add `import MarkdownUI` to your source code.

        ### Adding MarkdownUI to an Xcode project

        1. From the **File** menu, select **Add Packages…**
        1. Enter `https://github.com/gonzalezreal/swift-markdown-ui` into the
           *Search or Enter Package URL* search field
        1. Link **MarkdownUI** to your application target
        """
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var testData: [Site]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Site")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Site]
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TripMap")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
