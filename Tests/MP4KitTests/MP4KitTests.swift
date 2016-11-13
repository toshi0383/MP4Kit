import XCTest
@testable import MP4Kit

class MP4KitTests: XCTestCase {
    func parse(_ filename: String) {
        do {
            let mp4 = try MonolithicMP4FileParser(path: filename).parse()
            guard let container = mp4.container as? ISO14496Part12Container else {
                XCTFail()
                return
            }
            XCTAssert(container.ftyp.minorVersion == 512)
        } catch {
            XCTFail()
        }
    }

    func path(forResource name: String) -> String {
        return Bundle(for: MP4KitTests.self).path(forResource: name, ofType: nil)!
    }

    func testParseMp4() {
        parse(path(forResource: "ftyp"))
    }

    static var allTests: [(String, (MP4KitTests) -> () throws -> Void)] {
        return [
            ("testParseMp4", testParseMp4),
        ]
    }
}
