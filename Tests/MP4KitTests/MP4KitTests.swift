import XCTest
@testable import MP4Kit

class MP4KitTests: XCTestCase {
    func parse(_ filename: String) {
        do {
            let mp4 = try MP4(path: filename)
            XCTAssert(mp4.container.ftyp.minorVersion == 512)
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


    static var allTests : [(String, (MP4KitTests) -> () throws -> Void)] {
        return [
            ("testParseMp4", testParseMp4),
        ]
    }
}
