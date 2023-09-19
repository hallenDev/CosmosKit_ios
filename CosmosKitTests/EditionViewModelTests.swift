//swiftlint:disable function_body_length
//swiftlint:disable line_length
import XCTest
@testable import CosmosKit

class EditionViewModelTests: XCTestCase {

    func testCreate_fromEdition() {

        let json = readJSONData("Edition")

        do {
            let edition = try JSONDecoder().decode(Edition.self, from: json)

            let sut = EditionViewModel(from: edition)

            XCTAssertEqual(sut.title, "MONDAY, JULY 16 2018")
            XCTAssertEqual(sut.sections.count, 11)
            XCTAssertEqual(sut.sections[0].heading, "THE BIG STORIES")
            XCTAssertEqual(sut.sections[0].subHeading, "LEADING THE AGENDA")
            XCTAssertEqual(sut.sections[0].articles.count, 3)
            XCTAssertEqual(sut.sections[0].type, .articles)
            XCTAssertEqual(sut.sections[1].type, .articles)
            XCTAssertEqual(sut.sections[2].type, .articles)
            XCTAssertEqual(sut.sections[3].type, .articles)
            XCTAssertEqual(sut.sections[4].type, .widgets)
            XCTAssertEqual(sut.sections[4].widgets?.count, 1)
            XCTAssertEqual(sut.sections[5].type, .widgets)
            XCTAssertEqual(sut.sections[5].widgets?.count, 2)
            XCTAssertEqual(sut.sections[6].type, .articles)
            XCTAssertEqual(sut.sections[7].type, .widgets)
            XCTAssertEqual(sut.sections[7].widgets?.count, 2)
            XCTAssertEqual(sut.sections[8].type, .articles)
            XCTAssertEqual(sut.sections[9].type, .articles)
            XCTAssertEqual(sut.sections[10].type, .articles)
            XCTAssertEqual(sut.articleOrder, [
                5149503652888576,
                5634165009547264,
                5692592335355904,
                5137785908363264,
                5183871444320256,
                4789740079415296,
                6329812272545792,
                6015111428833280,
                6478812137127936,
                5630978613575680,
                5707532110659584,
                5923858137743360,
                5663284820705280,
                5419260885073920,
                5449299081035776,
                4870079321735168,
                5996794265731072,
                5457763253616640,
                4814213608374272,
                5169362239488000,
                5652720409116672,
                5939994665418752,
                6502944618840064,
                6031506594070528,
                5977543685439488]
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCreate_infoBlockEdition() {

        let json = readJSONData("InfoBlockEdition")

        do {
            let edition = try JSONDecoder().decode(Edition.self, from: json)

            let sut = EditionViewModel(from: edition)

            XCTAssertEqual(sut.title, "MONDAY, DECEMBER 24 2018")
            XCTAssertEqual(sut.sections.count, 6)
            XCTAssertEqual(sut.sections[0].heading, "THE BIG ISSUES")
            XCTAssertEqual(sut.sections[0].subHeading, "LEADING THE AGENDA")
            XCTAssertEqual(sut.sections[0].articles.count, 4)
            XCTAssertEqual(sut.sections[0].type, .articles)
            XCTAssertEqual(sut.sections[1].type, .articles)
            XCTAssertEqual(sut.sections[2].type, .articles)
            XCTAssertEqual(sut.sections[3].type, .widgets)
            XCTAssertEqual(sut.sections[3].widgets?.count, 2)
            XCTAssertEqual(sut.sections[4].type, .articles)
            XCTAssertEqual(sut.sections[5].type, .widgets)
            XCTAssertEqual(sut.sections[5].heading, "<p style=\"text-align: center;\">This is the final edition of Times Select for 2018. We will be back on January 2 2019.</p>")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCreate_fromArticles() {

        let json = readJSONData("SectionArticleList")
        let section = Section(name: "section", id: "section")

        do {
            let articles = try JSONDecoder().decode([Article].self, from: json)

            let sut = EditionViewModel(from: articles, section: SectionViewModel(section: section)!, endOfList: true)

            XCTAssertEqual(sut.title, "")
            XCTAssertEqual(sut.sections.count, 1)
            XCTAssertEqual(sut.sections[0].heading, "SECTION")
            XCTAssertEqual(sut.sections[0].subHeading, "")
            XCTAssertEqual(sut.sections[0].articles.count, 25)
            XCTAssertEqual(sut.articleOrder, [
                5707922315149312,
                5684516622434304,
                5410847480348672,
                6591524594778112,
                6329310130470912,
                5631147627249664,
                5719699115474944,
                5638219290902528,
                4847155034456064,
                5555636196605952,
                5702073911869440,
                5714893047070720,
                5409681799380992,
                5823985216389120,
                5670994454773760,
                6271177748119552,
                5741770952409088,
                5163046389415936,
                4899436463390720,
                5200778213982208,
                5704595057672192,
                5686830267629568,
                6328233570074624,
                5488213799993344,
                6222614955556864])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAddArticles() {

        let json = readJSONData("SectionArticleList")
        let section = Section(name: "Section", id: "section")
        let article = Article(title: "page2",
                              sectionTitle: "sectionTitle",
                              title2: nil,
                              title3: nil,
                              section: section,
                              subSection: nil,
                              adSections: nil,
                              published: 1,
                              modified: 2,
                              publication: ArticlePublication(identifier: "times-live"),
                              authors: [],
                              author: nil,
                              intro: "",
                              synopsis: "",
                              headerImage: nil,
                              widgets: [],
                              images: [],
                              key: 999,
                              slug: "test",
                              readDuration: 1,
                              contentType: "",
                              shareURL: nil,
                              access: true,
                              comments: true,
                              externalUrl: nil,
                              videoCount: 0,
                              hideInApp: false,
                              sponsor: nil,
                              marketData: nil)

        do {
            let articles = try JSONDecoder().decode([Article].self, from: json)
            var sut = EditionViewModel(from: articles, section: SectionViewModel(section: section)!, endOfList: true)

            sut.add(articles: [article], page: 2)

            let addedArticle = sut.sections.first?.articles.last
            XCTAssertEqual(addedArticle?.key, 999)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
