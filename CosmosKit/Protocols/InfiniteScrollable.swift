import Foundation

protocol InfiniteScrollable {
    var cellHeights: [IndexPath: CGFloat] { get set }
    var isScrollable: Bool { get set }
    var loadNextPage: (() -> Void)? { get set }
    var currentPage: Int { get set }
    var atEnd: Bool { get set }
}

extension InfiniteScrollable {

    public func loadNextPage() {
        if isScrollable {
            loadNextPage?()
        }
    }
}
