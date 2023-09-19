import XCTest

@testable import CosmosKit

class CosmosImagesTests: XCTestCase {

    func testLoadingOfAllImages() {

        for image in CosmosImages.Article.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.ArticleImage.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Auth.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Authors.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Bookmarks.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Nav.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.PastEditions.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Search.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Sections.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Videos.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

        for image in CosmosImages.Widgets.allCases {
            XCTAssertNotNil(UIImage(cosmosName: image), "Could not load : \(image)")
        }

    }
}
