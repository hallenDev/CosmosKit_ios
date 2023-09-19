//swiftlint:disable force_try force_cast line_length

import XCTest
@testable import CosmosKit

class WidgetTests: XCTestCase {

    func testCreate_ImageWidget() {

        let data = readJSONData("WidgetImage")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .image)
        let imagedata = sut.data as! ImageWidgetData
        XCTAssertEqual(imagedata.image.imageURL, "https://lh3.googleusercontent.com/tNwInqU9Dn-U0aAVaFCURmj8SpbpxK3D1HtCAwjiAVgUYUAz3G-vdvIHEB9AxpqXJtbKU693ypA6rMYPvXTArz2kiYwCFl0oUg")
        XCTAssertEqual(imagedata.image.title, "")
        XCTAssertEqual(imagedata.image.description, "Hyundai.   Picture: NEWSPRESS UK")
        XCTAssertEqual(imagedata.image.author, "photographer")
        XCTAssertEqual(imagedata.image.height, 362)
        XCTAssertEqual(imagedata.image.width, 512)

    }

    func testCreate_TextWidget() {

        let data = readJSONData("WidgetText")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .text)
        XCTAssertEqual((sut.data as! TextWidgetData).html, "<p>Seoul &mdash; Elliott Management, which announced earlier in April that had it bought about $1bn in shares of units of Hyundai Motor Group, stepped up its pressure on the South Korean conglomerate by making demands ranging from higher dividends to restructuring the group under a holding company.</p>\n<p>Elliott&rsquo;s proposals, which include combining Hyundai with Hyundai Mobis and raising dividends to as much as half of net income, have been relayed to the board of Hyundai Motor Group, it said. Group representatives weren&rsquo;t immediately available to comment.</p>")
    }

    func testCreate_TwitterWidget() {

        let data = readJSONData("WidgetTwitter")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .tweet)
        XCTAssertEqual((sut.data as! WebWidgetData).meta.html, "<blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Las Vegas utilities really don\u{2019}t want the strip to go solar <a href=\"https://t.co/IuQUJHdEje\">https://t.co/IuQUJHdEje</a> <a href=\"https://t.co/pSoCj5kJe1\">pic.twitter.com/pSoCj5kJe1</a></p>&mdash; WIRED (@WIRED) <a href=\"https://twitter.com/WIRED/status/707826078891577344?ref_src=twsrc%5Etfw\">March 10, 2016</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n")
    }

    func testCreate_InstagramWidget() {

        let data = readJSONData("WidgetInstagram")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .instagram)
        XCTAssertEqual((sut.data as! WebWidgetData).meta.html, "<blockquote class=\"instagram-media\" data-instgrm-captioned data-instgrm-permalink=\"https://www.instagram.com/p/BC_VQLhubaJ/\" data-instgrm-version=\"8\" style=\" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:658px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);\"><div style=\"padding:8px;\"> <div style=\" background:#F8F8F8; line-height:0; margin-top:40px; padding:50.0% 0; text-align:center; width:100%;\"> <div style=\" background:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAsCAMAAAApWqozAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAMUExURczMzPf399fX1+bm5mzY9AMAAADiSURBVDjLvZXbEsMgCES5/P8/t9FuRVCRmU73JWlzosgSIIZURCjo/ad+EQJJB4Hv8BFt+IDpQoCx1wjOSBFhh2XssxEIYn3ulI/6MNReE07UIWJEv8UEOWDS88LY97kqyTliJKKtuYBbruAyVh5wOHiXmpi5we58Ek028czwyuQdLKPG1Bkb4NnM+VeAnfHqn1k4+GPT6uGQcvu2h2OVuIf/gWUFyy8OWEpdyZSa3aVCqpVoVvzZZ2VTnn2wU8qzVjDDetO90GSy9mVLqtgYSy231MxrY6I2gGqjrTY0L8fxCxfCBbhWrsYYAAAAAElFTkSuQmCC); display:block; height:44px; margin:0 auto -44px; position:relative; top:-22px; width:44px;\"></div></div> <p style=\" margin:8px 0 0 0; padding:0 4px;\"> <a href=\"https://www.instagram.com/p/BC_VQLhubaJ/\" style=\" color:#000; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px; text-decoration:none; word-wrap:break-word;\" target=\"_blank\">Morning lights up the Golden Gate Bridge | Photo by @tobyharriman</a></p> <p style=\" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; line-height:17px; margin-bottom:0; margin-top:8px; overflow:hidden; padding:8px 0 7px; text-align:center; text-overflow:ellipsis; white-space:nowrap;\">A post shared by <a href=\"https://www.instagram.com/earthpix/\" style=\" color:#c9c8cd; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:normal; line-height:17px;\" target=\"_blank\">   Earthpix  </a> (@earthpix) on <time style=\" font-family:Arial,sans-serif; font-size:14px; line-height:17px;\" datetime=\"2016-03-15T21:56:54+00:00\">Mar 15, 2016 at 2:56pm PDT</time></p></div></blockquote>\n<script async defer src=\"//www.instagram.com/embed.js\"></script>")
        XCTAssertEqual(sut.getViewModel()?.type, .instagram)
        XCTAssertEqual((sut.getViewModel() as? WebViewModel)?.isInstagram, true)
    }

    func testCreate_YoutubeWidget() {

        let data = readJSONData("WidgetYoutube")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .youtube)
    }

    func testCreate_GoogleMapsWidget() {

        let data = readJSONData("WidgetGoogleMap")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .googleMaps)
    }

    func testCreate_JWPlayerWidget() {

        let data = readJSONData("WidgetJWPlayer")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .jwplayer)
    }

    func testCreate_FacebookPostWidget() {

        let data = readJSONData("WidgetFacebookPost")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .facebookPost)
    }

    func testCreate_FacebookVideoWidget() {

        let data = readJSONData("WidgetFacebookVideo")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .facebookVideo)
    }

    func testCreate_QuoteWidget() {

        let data = readJSONData("WidgetQuote")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .quote)
    }

    func testCreate_TextBlockWidget() {

        let data = readJSONData("WidgetInfoBlock")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .infoblock)
    }

    func testCreate_GalleryWidget() {

        let data = readJSONData("WidgetGallery")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .gallery)
    }

    func testCreate_RelatedArticlesWidget() {

        let data = readJSONData("WidgetRelatedArticles")

        do {
            let sut = try JSONDecoder().decode(Widget.self, from: data)

            XCTAssertEqual(sut.type, .relatedArticles)
            let widgetData = sut.data as! RelatedArticlesWidgetData
            XCTAssertEqual(widgetData.articles?.count, 3)
            XCTAssertEqual(widgetData.meta.title, "Read Some other stuff")
        } catch {
            XCTFail("failed to decode \(error.localizedDescription)")
        }
    }

    func testCreate_ArticleListFromJSON() {

        let data = readJSONData("WidgetArticleList")

        do {
            let sut = try JSONDecoder().decode(Widget.self, from: data)

            XCTAssertEqual(sut.type, .articleList)
            let widgetData = sut.data as! ArticleListWidgetData
            XCTAssertEqual(widgetData.articleIds.count, 5)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCreate_HMTLFromJSON() {

        let data = readJSONData("WidgetCrossword")

        do {
            let sut = try JSONDecoder().decode(Widget.self, from: data)

            XCTAssertEqual(sut.type, .html)
            let widgetData = sut.data as! TextWidgetData
            XCTAssertEqual(widgetData.html, "Cryptic:\n<iframe height=\"700\" width=\"100%\" allowfullscreen=\"true\" \n        style=\"border:none;width: 100% !important;position: static;display: block !important;margin: 0 !important;\"  \n        name=\"tiso\" src=\"https://cdn2.amuselabs.com/tb/date-picker?set=tiso-cryptic&theme=tb\"></iframe>")

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCreate_UnsupportedWidget() {

        let data = readJSONData("WidgetUnsupported")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .unsupported)
    }

    func testCreate_AccordionWidget() {

        let data = readJSONData("WidgetAccordion")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .accordion)
    }

    func testCreate_IonoWidget() {

        let data = readJSONData("WidgetIono")

        let sut = try! JSONDecoder().decode(Widget.self, from: data)

        XCTAssertEqual(sut.type, .iono)
    }
}
