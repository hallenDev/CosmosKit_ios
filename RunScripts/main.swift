import Foundation

// MARK: String Asset Enum Extension

let tab = "    "

extension String {
    private func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    }

    private func lowercasingFirstLetter() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    private func removedInvalidEnumCharacters() -> String {
        func fix(_ value: String) -> String {
            value.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "_", with: "")
        }

        if let escapedValue = removingPercentEncoding {
            return fix(escapedValue)
        } else {
            return fix(self)
        }
    }

    func validEnumCaseIdentifier() -> String {
        removedInvalidEnumCharacters().lowercasingFirstLetter()
    }

    func validEnumIdentifier() -> String {
        removedInvalidEnumCharacters().capitalizingFirstLetter()
    }
}

// MARK: FileManager Asset Catalog Extension

extension FileManager {
    /// Enumerates all the sub directories of and url having a given extension.
    ///
    /// - parameter url: The root url
    /// - parameter ext: The extension of the searched subdirectories (without the '.')
    ///
    /// - returns: An array containing all the urls of the subdirectories
    func findSubDirectories(from url: URL, withExtension ext: String) -> [URL] {
        let directoryEnumerator = enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey])
        var result = [URL]()

        while let element = directoryEnumerator?.nextObject() as? URL {
            if (try? element.resourceValues(forKeys: [.isDirectoryKey]).allValues[.isDirectoryKey]) as? Bool == true {
                if element.pathExtension.lowercased() == ext {
                    directoryEnumerator?.skipDescendants()
                    result.append(element)
                }
            }
        }

        return result
    }

    /// Enumerates all the assets catalogs
    func findAssetsCatalogs(form url: URL) -> [URL] {
        findSubDirectories(from: url, withExtension: "xcassets")
    }

    /// Enumerates all the color sets
    func findImageSets(form url: URL) -> [URL] {
        findSubDirectories(from: url, withExtension: "imageset").sorted { $0.absoluteString < $1.absoluteString }
    }
}

// MARK: EnumStruct

public struct EnumStruct: Comparable {
    let bundleIdentifier: String?
    let catalog: String
    let name: String
    var values: String
    var enums: [String: EnumStruct]
    let parentName: String

    init(name: String, catalog: String, bundleIdentifier: String? = nil, parentName: String = "") {
        self.name = name.validEnumIdentifier()
        values = ""
        enums = [String: EnumStruct]()
        self.bundleIdentifier = bundleIdentifier
        self.catalog = catalog
        self.parentName = parentName
    }

    func isEmpty() -> Bool {
        enums.isEmpty && values.count == 0
    }

    /// Produces enum declaration with modifier if specified.
    private func enumDeclaration(modifier: String?, name: String, enumType: String, tabIndentation: String) -> String {
        // public enum SomeEnum: String, CaseIterable {
        if let modifier = modifier {
            return "\(tabIndentation)\(modifier) enum \(name)\(enumType) {\n"
        } else {
            // enum SomeEnum: String, CaseIterable {
            return "\(tabIndentation)enum \(name)\(enumType) {\n"
        }
    }

    func process(tabIndentation: String) -> (entries: String, names: [String]) {
        func processChildren() -> (entries: String, names: [String]) {
            if enums.isEmpty {
                return ("", [String]())
            } else {
                var childEntries: (entries: String, names: [String]) = ("", [String]())
                let sortedValues = enums.values.sorted { $0.name < $1.name }
                for child in sortedValues {
                    let grandChildren = child.process(tabIndentation: "\(tabIndentation)\(tab)")
                    let entries = "\(childEntries.entries)\n\(grandChildren.entries)"
                    let names = childEntries.names + grandChildren.names
                    childEntries = (entries: entries, names: names)
                }
                return childEntries
            }
        }

        let modifier: String? = catalogIsPublic ? "public" : nil
        let children: (entries: String, names: [String]) = processChildren()
        let enumType: String

        let namesToAdd: [String]
        let fullyQualifiedParentName: String = parentName == "" ? name : "\(parentName).\(name)"
        if values.count == 0 {
            enumType = ""
            namesToAdd = [String]()
        } else {
            enumType = ": String, CaseIterable"
            namesToAdd = [fullyQualifiedParentName]
        }

        if let _ = bundleIdentifier {
            let definition = "import UIKit\n"
            let enumBundle = "\(tab)static let bundle = Bundle.cosmos\n"
            let enumContent = "\(definition)\n\(enumDeclaration(modifier: modifier, name: name, enumType: enumType, tabIndentation: tabIndentation))\(children.entries)\(values)\n\(enumBundle)\(tabIndentation)}\n"
            return (entries: enumContent, names: children.names + namesToAdd)
            //
        } else {
            let enumContent = "\(enumDeclaration(modifier: modifier, name: name, enumType: enumType, tabIndentation: tabIndentation))\(children.entries)\(values)\(tabIndentation)}\n"
            return (entries: enumContent, names: children.names + namesToAdd)
        }
    }

    mutating func append(components: [String], tabIndentation: String) {
        if components.count == 2 {
            let root = components.first!
            if root.contains(".imageset") {
                let rootValue = root.components(separatedBy: ".imageset").first!
                let cleanedRootValue: String = rootValue.validEnumCaseIdentifier()
                let caseEntry: String
                let escapedRootValue = rootValue.removingPercentEncoding!
                if cleanedRootValue == escapedRootValue {
                    caseEntry = cleanedRootValue
                } else {
                    caseEntry = "\(cleanedRootValue) = \"\(escapedRootValue)\""
                }
                values = values + "\(tabIndentation)case \(caseEntry)\n"
            }
        } else if components.count > 2 {
            let root = components.first!
            let children: [String] = components.suffix(components.count - 1)
            if var subEnum = enums[root] {
                subEnum.append(components: children, tabIndentation: "\(tabIndentation)\(tab)")
                enums[root] = subEnum
            } else {
                let fullyQualifiedParentName: String = parentName == "" ? name : "\(parentName).\(name)"
                var enumStruct = EnumStruct(name: root, catalog: catalog, parentName: fullyQualifiedParentName)
                enumStruct.append(components: children, tabIndentation: "\(tabIndentation)\(tab)")
                enums[root] = enumStruct
            }
        } else {
            print("Invalid components count.")
        }
    }

    mutating func append(value: String, tabIndentation: String) {
        let components = value.components(separatedBy: "/")
        append(components: components, tabIndentation: tabIndentation)
    }

    public static func < (lhs: EnumStruct, rhs: EnumStruct) -> Bool {
        lhs.name.compare(rhs.name) == .orderedAscending
    }

    public static func == (lhs: EnumStruct, rhs: EnumStruct) -> Bool {
        lhs.name.compare(rhs.name) == .orderedSame
    }
}

// MARK: Launch Arguments

var catalogIsPublic = true
var rootSearchDir: String?
var testDir: String?
var generateSubDir: String?

let arguments = CommandLine.arguments
// Initialize variables based on launch arguments.
for argument in arguments {
    if argument == "catalogIsPublic" {
        catalogIsPublic = true
    }
    if argument.hasPrefix("searchDir=") {
        let components = argument.components(separatedBy: "=")
        rootSearchDir = components.last
    }
    if argument.hasPrefix("testDir=") {
        let components = argument.components(separatedBy: "=")
        testDir = components.last
    }
    if argument.hasPrefix("generateSubDir=") {
        let components = argument.components(separatedBy: "=")
        generateSubDir = components.last
    }
}

let fileManager = FileManager.default

// MARK: Environment Variables

let sourceRoot = ProcessInfo.processInfo.environment["SOURCE_ROOT"]!
/// Bundle Identifier used when loading images from bundle.
let bundleIdentifier = ProcessInfo.processInfo.environment["PRODUCT_BUNDLE_IDENTIFIER"]!

// Project base directory
let rootPathURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
// Directory where the generated file should go
let filePathURL = generateSubDir != nil ? rootPathURL.appendingPathComponent(generateSubDir!).appendingPathComponent("Generated") : rootPathURL.appendingPathComponent("Generated")
let sourceURL = URL(fileURLWithPath: sourceRoot)

let unitTestsDir: URL?
if let testDir = testDir {
    unitTestsDir = sourceURL.appendingPathComponent(testDir).appendingPathComponent("Image Catalog Tests").appendingPathComponent("Generated")
} else {
    unitTestsDir = nil
}

/// Retreive the current year for header copyright purposes.
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy"
let currentYear = dateFormatter.string(from: Date())

let fileHeader = """
// •••••••••••••••••••••••••••••••••••••••••••••••••••••
// • GENERATED FILE                                    •
// •••••••••••••••••••••••••••••••••••••••••••••••••••••


"""

/// Finds all the assets catalogs
let catalogs: [URL]
if let rootSearchDir = rootSearchDir {
    catalogs = fileManager.findAssetsCatalogs(form: rootPathURL.appendingPathComponent(rootSearchDir))
} else {
    catalogs = fileManager.findAssetsCatalogs(form: rootPathURL)
}

for assetCatalog in catalogs {
    let catalogName = assetCatalog.deletingPathExtension().lastPathComponent
    let imageSets = fileManager.findImageSets(form: assetCatalog)
    let CatalogPath = assetCatalog.absoluteString
    let catalogEnumName = "\(catalogName)Images"
    var rootEnum = EnumStruct(name: catalogEnumName, catalog: catalogEnumName, bundleIdentifier: bundleIdentifier)

    for imageSet in imageSets {
        if let path = imageSet.absoluteString.components(separatedBy: CatalogPath).last {
            rootEnum.append(value: path, tabIndentation: "\(tab)")
        }
    }

    if rootEnum.isEmpty() {
        continue
    }

    // Create the root content and create the nested enum structure.
    print("1. Generating Enum Structure for \(catalogName).")
    let rootContent: (entries: String, names: [String]) = rootEnum.process(tabIndentation: "")
    // Append the UIImage extensions and unit tests.
    print("2. Creating Image extensions for \(catalogName).")
    let modifier: String? = catalogIsPublic ? "public" : nil
    var imageExtensions: String = "extension UIImage {\n"

    var tests: String = ""

    for enumName in rootContent.names.sorted() {
        let modifierText = modifier != nil ? "\(modifier!) " : ""
        imageExtensions = "\(imageExtensions)\(tab)\(modifierText)convenience init(cosmosName name: \(enumName)) {\n\(tab)\(tab)self.init(named: name.rawValue, in: \(rootEnum.name).bundle, compatibleWith: nil)!\n\(tab)}\n"
        tests = "\(tests)\n\(tab)\(tab)for image in \(enumName).allCases {\n\(tab)\(tab)\(tab)XCTAssertNotNil(UIImage(cosmosName: image), \"Could not load : \\(image)\")\n\(tab)\(tab)}\n"
    }
    imageExtensions = "\(imageExtensions)}\n"

    // MARK: Enum File Population

    print("3. Populating File for \(catalogName).")
    let fileContent = "\(fileHeader)// • \(catalogName)\n\(rootContent.entries)\n\(imageExtensions)"

    // MARK: Enum File Generation

    do {
        if !fileManager.fileExists(atPath: filePathURL.path) {
            try fileManager.createDirectory(at: filePathURL, withIntermediateDirectories: true, attributes: nil)
        }

        /// Writes the generated file
        try fileContent.write(to: filePathURL.appendingPathComponent("\(catalogEnumName)-Generated.swift"), atomically: true, encoding: .utf8)

        print("✅ Enum File Saved to \(filePathURL.path)")
    } catch {
        print(error)
        exit(1)
    }

    // MARK: Unit Test Generation

    let testContents: String = """
    import XCTest

    @testable import \(ProcessInfo.processInfo.environment["EXECUTABLE_NAME"]!)

    class \(rootEnum.name)Tests: XCTestCase {

        func testLoadingOfAllImages() {
    \(tests)
        }
    }\n
    """

    // MARK: Unit Test File Generation

    if let unitTestsDir = unitTestsDir {
        do {
            if !fileManager.fileExists(atPath: unitTestsDir.path) {
                try fileManager.createDirectory(at: unitTestsDir, withIntermediateDirectories: true, attributes: nil)
            }

            /// Writes the generated file
            try testContents.write(to: unitTestsDir.appendingPathComponent("\(catalogEnumName)Tests-Generated.swift"), atomically: true, encoding: .utf8)

            print("✅ Unit Test Saved to \(unitTestsDir.path)")
        } catch {
            print(error)
            exit(1)
        }
    }
}
