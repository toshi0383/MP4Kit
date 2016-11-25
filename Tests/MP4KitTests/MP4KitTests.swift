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
            let ftyp = container.ftyp
            XCTAssertEqual(ftyp.size, 36)
            XCTAssertEqual(ftyp.type, .ftyp)
            XCTAssert(ftyp.largesize == nil)
            XCTAssert(ftyp.usertype == nil)
            XCTAssertEqual(ftyp.majorBrand, "isom")
            XCTAssertEqual(ftyp.minorVersion, 512)
            XCTAssertEqual(ftyp.compatibleBrands.joined(),
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

    func testWriteMp4() {
        let path = temporaryFilePath()
        print(path)
        let ftyp = FileTypeBox()
        ftyp.size = 36
        ftyp.type = .ftyp
        ftyp.majorBrand = "isom"
        ftyp.minorVersion = 512
        ftyp.compatibleBrands = ["isom", "iso2", "avc1", "mp41", "iso5"]
        let moov = MovieBox()
        moov.type = .moov
        do {
            let w = ByteWriter(path: path)
            var bytes = try ftyp.encode()
            bytes += try moov.encode()
            w.write(bytes)
            w.close()
            let url = URL(fileURLWithPath: path)
            let data = Data(bytes: bytes)
            XCTAssertEqual(try Data(contentsOf: url), data)
            print(data.map{$0})
        } catch {
            XCTFail("\(error)")
        }
        do {
            let mp4 = try MonolithicMP4FileParser(path: path).parse()
            guard let container = mp4.container as? ISO14496Part12Container else {
                XCTFail()
                return
            }
            let ftyp = container.ftyp
            XCTAssertEqual(ftyp.size, 36)
            XCTAssertEqual(ftyp.type, .ftyp)
            XCTAssert(ftyp.largesize == nil)
            XCTAssert(ftyp.usertype == nil)
            XCTAssertEqual(ftyp.majorBrand, "isom")
            XCTAssertEqual(ftyp.minorVersion, 512)
            XCTAssertEqual(ftyp.compatibleBrands.joined(),
                           ["isom", "iso2", "avc1", "mp41", "iso5"].joined())
        } catch {
            XCTFail("\(error)")
        }
    }

    static var allTests: [(String, (MP4KitTests) -> () throws -> Void)] {
        return [
            ("testParseMp4", testParseMp4),
            ("testParseMp4Performance", testParseMP4Performance),
            ("testWriteMp4", testWriteMp4),
        ]
    }
}
