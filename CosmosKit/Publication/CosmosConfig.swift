import Foundation
import UIKit

public struct FilteredPublication {
    let id: String

    public init(id: String) {
        self.id = id
    }
}
public typealias FilteredPublicationArray = [FilteredPublication]
public typealias PublicationArray = [Publication]

public struct CosmosConfig {

    let publication: Publication
    let apiVersion: Int
    let customArticlePublications: PublicationArray?
    let customEditionPublications: PublicationArray?
    let customRelatedPublications: PublicationArray?
    let customArticleWidgetPublications: PublicationArray?
    let filteredPublications: FilteredPublicationArray?
    let session: URLSession

    public init(publication: Publication,
                customArticlePublications: PublicationArray? = nil,
                customEditionPublications: PublicationArray? = nil,
                customRelatedPublications: PublicationArray? = nil,
                customArticleWidgetPublications: PublicationArray? = nil,
                filteredPublications: FilteredPublicationArray? = nil,
                apiVersion: Int? = 1) {

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["User-Agent": UserAgentBuilder().build(),
                                        "Accept-Encoding": "gzip",
                                        "consumer-key": publication.consumerKey]
        self.init(publication: publication,
                  customArticlePublications: customArticlePublications,
                  customEditionPublications: customEditionPublications,
                  customRelatedPublications: customRelatedPublications,
                  customArticleWidgetPublications: customArticleWidgetPublications,
                  filteredPublications: filteredPublications,
                  apiVersion: apiVersion,
                  session: URLSession(configuration: config))
    }

    init(publication: Publication,
         customArticlePublications: PublicationArray? = nil,
         customEditionPublications: PublicationArray? = nil,
         customRelatedPublications: PublicationArray? = nil,
         customArticleWidgetPublications: PublicationArray? = nil,
         filteredPublications: FilteredPublicationArray? = nil,
         apiVersion: Int? = 1,
         session: URLSession) {

        self.publication = publication
        self.apiVersion = apiVersion ?? 1
        self.customArticlePublications = customArticlePublications
        self.customEditionPublications = customEditionPublications
        self.customRelatedPublications = customRelatedPublications
        self.customArticleWidgetPublications = customArticleWidgetPublications
        self.filteredPublications = filteredPublications
        self.session = session
    }
}
