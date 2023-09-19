import Foundation

struct AuthorsViewModel {

    var authors: [AuthorViewModel]

    var count: Int {
        return authors.count
    }

    mutating func add(authors: [AuthorViewModel]) {
        self.authors.append(contentsOf: authors)
    }

    init(authors: [AuthorViewModel]) {
        self.authors = authors
    }
}
