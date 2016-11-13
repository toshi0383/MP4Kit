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

    func testParseMp4() {
        parse("./Resources/ftyp")
    }

    func testExample() {
    }


    static var allTests : [(String, (MP4KitTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
            ("testParseMp4", testParseMp4),
        ]
    }
}
