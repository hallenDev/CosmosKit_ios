@testable import CosmosKit
import XCTest

class TestableURLSession: URLSession {

    var testTasks = [TestableTask()]
    var requests = [URLRequest]()
    var index = 0

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let testTask = testTasks[index]
        index += 1
        testTask.completion = completionHandler
        return testTask
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let testTask = testTasks[index]
        requests.append(request)
        index += 1
        testTask.completion = completionHandler
        return testTask
    }
}

class TestableTask: URLSessionDataTask {
    var completion: ((Data?, URLResponse?, Error?) -> Void)?
    var testData: Data?
    var testResponse: URLResponse = {
        let response = HTTPURLResponse(url: URL(string: "http://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return response!
    }()
    var testError: Error?

    override func resume() {
        completion?(testData, testResponse, testError)
    }
}

class TestableListTable: UITableView {
    func createArticleSummaryCell() -> ArticleSummaryCell {
        let cell = ArticleSummaryCell()
        cell.articleImage = UIImageView(image: UIImage())
        cell.articleTitle = ArticleListTitleLabel()
        cell.articleSection = ArticleListSectionLabel()
        cell.videoTreatment = UIImageView(image: UIImage())
        cell.bottomAdViewHeightConstraint = NSLayoutConstraint()
        cell.topAdViewHeightConstraint = NSLayoutConstraint()
        cell.topAdView = AdContainerView()
        cell.bottomAdView = AdContainerView()
        return cell
    }

    func createFeaturedArticleSummaryCell() -> ArticleSummaryCell {
        let cell = ArticleSummaryCell()
        cell.articleImage = UIImageView(image: UIImage())
        cell.articleTitle = ArticleListTitleLabel()
        cell.articleSection = ArticleListSectionLabel()
        return cell
    }

    func createExpandedVideoCell() -> VideoCell {
        let cell = VideoCell()
        cell.thumbnail = UIImageView(image: UIImage())
        cell.title = VideoCellTitleLabel()
        cell.section = VideoCellSectionLabel()
        cell.published = VideoCellTimeLabel()
        cell.sectionBlock = VideoSectionBlock()
        return cell
    }

    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        switch identifier {
        case "ArticleSummaryCell":
            return createArticleSummaryCell()
        case "FeaturedArticleSummaryCell":
            return createFeaturedArticleSummaryCell()
        case "ExpandedVideoCell":
            return createExpandedVideoCell()
        default:
            fatalError("Couldn't dequeue cell")
        }
    }
}
