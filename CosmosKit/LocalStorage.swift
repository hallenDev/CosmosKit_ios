import Foundation

protocol Storable {
    func persist(_ edition: Edition?) -> Bool
    func persist(_ article: Article?) -> Bool
    func edition(key: Int64) -> Edition?
    func edition(filename: String) -> Edition?
    func removeEdition(filename: String) -> Bool
    func removeEdition(key: Int64) -> Bool
    func article(key: Int64) -> Article?
    func removeArticle(key: Int64?) -> Bool
    func getBookmarks() -> [Int64]?
    func getPersistedEditions() -> [Edition]?
    func removePersistedEditions(excluding keys: [Int64])
    func removeAllBookmarks() -> Bool
    func isBookmark(key: Int64) -> Bool
    func isPersisted(key: Int64) -> Bool
    func exists(at path: String) -> Bool
}

struct LocalStorage: Storable {

    private var bookmarkDirectory: URL {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("bookmarks")
    }

    private var documentsDirectory: URL {
        let manager = FileManager.default
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func persist(_ edition: Edition?) -> Bool {
        guard let edition = edition else { return false }

        let file = "\(edition.key).json"
        do {
            let json = try JSONEncoder().encode(edition)
            return NSKeyedArchiver.archiveRootObject(json, toFile: filePath(key: file))
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func persist(_ article: Article?) -> Bool {
        guard let article = article else { return false }

        let file = "\(article.key).json"
        do {
            let json = try JSONEncoder().encode(article)
            return NSKeyedArchiver.archiveRootObject(json, toFile: bookmarkPath(key: file))
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func edition(key: Int64) -> Edition? {
        return self.edition(filename: "\(key)")
    }

    func edition(filename: String) -> Edition? {
        let file = "\(filename).json"

        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath(key: file)) as? Data {
            do {
                return try JSONDecoder().decode(Edition.self, from: data)
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }

    func removeEdition(key: Int64) -> Bool {
        return self.removeEdition(filename: "\(key)")
    }

    func removeEdition(filename: String) -> Bool {
        let file = "\(filename).json"
        let path = filePath(key: file)
        if exists(at: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                print(error)
                return false
            }
        } else {
            return true
        }
    }

    func article(key: Int64) -> Article? {
        let file = "\(key).json"
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: bookmarkPath(key: file)) as? Data {
            do {
                return try JSONDecoder().decode(Article.self, from: data)
            } catch {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }

    func removeArticle(key: Int64?) -> Bool {
        guard let key = key else { return false }

        let path = bookmarkPath(key: "\(key).json")
        if exists(at: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                print(error)
                return false
            }
        } else {
            return true
        }
    }

    func getBookmarks() -> [Int64]? {
        if let urls = try?
            FileManager.default.contentsOfDirectory(at: bookmarkDirectory,
                                                    includingPropertiesForKeys: [.contentModificationDateKey],
                                                    options: .skipsHiddenFiles) {
            let results = urls.map { url in
                (
                    url.lastPathComponent.replacingOccurrences(of: ".json", with: ""),
                    (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                )
            }
            // swiftlint:enable line_length
            let sortedResults = results.sorted(by: { $0.1 > $1.1 }).compactMap { Int64($0.0) }
            return sortedResults
        } else {
            return nil
        }
    }

    func removeAll() -> Bool {
        self.removePersistedEditions(excluding: [])
        return self.removeAllBookmarks()
    }

    func getPersistedEditions() -> [Edition]? {
        if let urls = try?
            FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                    includingPropertiesForKeys: [],
                                                    options: .skipsHiddenFiles) {
            let results = urls.map { $0.lastPathComponent.replacingOccurrences(of: ".json", with: "") }
            let filteredResults = results.filter { $0 != "bookmarks" }
            let editions = filteredResults.compactMap { self.edition(filename: $0) }
            return editions.sorted { $0.published > $1.published }
        } else {
            return nil
        }
    }

    func removePersistedEditions(excluding keys: [Int64]) {
        let editionNames = keys.map { String($0) }
        let manager = FileManager.default
        if let documentDir = manager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let urls = try? FileManager.default.contentsOfDirectory(at: documentDir,
                                                    includingPropertiesForKeys: [],
                                                    options: .skipsHiddenFiles) {

            let results = urls.map {
                $0.lastPathComponent.replacingOccurrences(of: ".json", with: "")
            }.filter { $0 != "bookmarks" }

            for result in results {
                if !editionNames.contains(result) {
                    _ = removeEdition(filename: result)
                }
            }
        }
    }

    func removeAllBookmarks() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: bookmarkDirectory.path)
            return true
        } catch {
            print(error)
            return false
        }
    }

    func isBookmark(key: Int64) -> Bool {
        let file = "\(key).json"
        let path = bookmarkPath(key: file)
        return exists(at: path)
    }

    func isPersisted(key: Int64) -> Bool {
        let file = "\(key).json"
        return exists(at: filePath(key: file))
    }

    func exists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    private func filePath(key: String) -> String {
        createDirectoryIfNil(documentsDirectory)
        return documentsDirectory.appendingPathComponent(key).path
    }

    private func bookmarkPath(key: String) -> String {
        createDirectoryIfNil(bookmarkDirectory)
        return self.filePath(key: "bookmarks/\(key)")
    }

    private func createDirectoryIfNil(_ url: URL) {
        do {
            _ = try FileManager.default.createDirectory(at: url,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
        } catch {
            print(error)
        }
    }
}
