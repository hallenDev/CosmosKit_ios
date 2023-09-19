@testable import CosmosKit
import XCTest

class TranslationTests: XCTestCase {

    func testTranslations_en() {

        for translation in TranslationKeys.allCases {
            let destination = LanguageManager.shared.translate(key: translation, returnOriginal: false)
            if destination == LanguageManager.shared.translationNotFound {
                XCTFail("English translation missing: Key: \'\(translation)\', Value: \'\(translation.rawValue)\'")
                break
            }
        }
    }

    func testTranslations_af() {

        for translation in TranslationKeys.allCases {
            let destination = LanguageManager.shared.translate(key: translation, returnOriginal: false, overrideLanguage: .afZA)
            if destination == LanguageManager.shared.translationNotFound {
                XCTFail("Afrikaans translation missing: Key: \'\(translation)\', Value: \'\(translation.rawValue)\'")
                break
            }
        }
    }

}
