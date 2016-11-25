import XCTest
@testable import MP4Kit

func path(forResource name: String) -> String? {
    #if SWIFT_PACKAGE
        return name
    #else
        return Bundle(for: MP4KitTests.self)
            .path(forResource: name.components(separatedBy: "/").last!, ofType: nil)
    #endif
}

class MP4KitTests: XCTestCase {
    func parseTest(_ filename: String) {
        do {
            let mp4 = try MonolithicMP4FileParser(path: filename).parse()
            guard let container = mp4.container as? ISO14496Part12Container else {
                XCTFail()
                return
            }
            XCTAssertEqual(container.ftyp.size, 36)
            XCTAssertEqual(container.ftyp.type, .ftyp)
            XCTAssert(container.ftyp.largesize == nil)
            XCTAssert(container.ftyp.usertype == nil)
            XCTAssertEqual(container.ftyp.majorBrand, "isom")
            XCTAssertEqual(container.ftyp.minorVersion, 512)
            XCTAssertEqual(container.ftyp.compatibleBrands.joined(),
                           ["isom", "iso2", "avc1", "mp41", "iso5"].joined())

            // moov
            let moov = container.moov
            XCTAssertEqual(moov.size, 228961)
            XCTAssertEqual(moov.type, .moov)
            XCTAssert(moov.largesize == nil)
            XCTAssert(moov.usertype == nil)

            // mvhd
            XCTAssertEqual(moov.mvhd.size, 108)
            XCTAssertEqual(moov.mvhd.type, .mvhd)
            XCTAssert(moov.mvhd.largesize == nil)
            XCTAssert(moov.mvhd.usertype == nil)
            XCTAssertEqual(moov.mvhd.creationTime, Constants.referenceDate)
            XCTAssertEqual(moov.mvhd.modificationTime, Constants.referenceDate)
            XCTAssertEqual(moov.mvhd.timescale, 1000)
            XCTAssertEqual(moov.mvhd.duration, 596416)
            XCTAssertEqual(moov.mvhd.rate, 1.0)
            XCTAssertEqual(moov.mvhd.volume, 1.0)
            XCTAssertEqual(moov.mvhd.matrix?.a, 1)
            XCTAssertEqual(moov.mvhd.matrix?.b, 0)
            XCTAssertEqual(moov.mvhd.matrix?.u, 0)
            XCTAssertEqual(moov.mvhd.matrix?.c, 0)
            XCTAssertEqual(moov.mvhd.matrix?.d, 1)
            XCTAssertEqual(moov.mvhd.matrix?.v, 0)
            XCTAssertEqual(moov.mvhd.matrix?.x, 0)
            XCTAssertEqual(moov.mvhd.matrix?.y, 0)
            XCTAssertEqual(moov.mvhd.matrix?.w, 1)
            XCTAssertEqual(moov.mvhd.preDefined, [0, 0, 0, 0, 0, 0])
            XCTAssertEqual(moov.mvhd.nextTrackID, 4294967295)

            // mdat
            let mdat = container.mdat
            XCTAssertEqual(mdat!.size, 42970771)
            XCTAssertEqual(mdat!.type, .mdat)
            XCTAssert(mdat!.largesize == nil)
            XCTAssert(mdat!.usertype == nil)
            XCTAssertEqual(mdat!.data[0..<10], [0, 0, 1, 236, 6, 5, 255, 232, 220, 69])
            XCTAssert(mdat!.data.count < Constants.bufferSize)

        } catch {
            XCTFail("\(error)")
        }
    }

    func testParseMp4() {
        guard let path = path(forResource: "./Resources/ftyp") else {
            XCTFail("File not found.")
            return
        }
        parseTest(path)
    }

    func testParseMP4Performance() {
        guard let path = path(forResource: "./Resources/ftyp") else {
            XCTFail("File not found.")
            return
        }
        self.measure {
            do {
                _ = try MonolithicMP4FileParser(path: path).parse()
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    static var allTests: [(String, (MP4KitTests) -> () throws -> Void)] {
        return [
            ("testParseMp4", testParseMp4),
            ("testParseMp4Performance", testParseMP4Performance),
        ]
    }
}
