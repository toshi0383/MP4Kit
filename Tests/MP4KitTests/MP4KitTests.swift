import XCTest
@testable import MP4Kit

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
            XCTAssertEqual(moov.mvhd.matrix!, Matrix.rotate0)
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
            XCTAssert(mdat!.data.count < ByteReader.Constants.bufferSize)

            // meta
            if let meta = moov.meta {
                XCTAssertEqual(meta.size, 62)
            } else {
                XCTFail("moov/meta does not exist.")
            }

            // trak
            let trak = moov.traks[0]
            XCTAssertEqual(trak.size, 83639)

            let tkhd = trak.tkhd!
            XCTAssertEqual(tkhd.creationTime, Constants.referenceDate)
            let date = Date.utc(
                year: 2016, month: 7, day: 21, hour: 6, minute: 10, second: 36
            )
            XCTAssertEqual(tkhd.modificationTime, date)
            XCTAssertEqual(tkhd.trackID, 1)
            XCTAssertEqual(tkhd.duration, 596416)
            XCTAssertEqual(tkhd.layer!, 0)
            XCTAssertEqual(tkhd.volume, 0.0)
            XCTAssertEqual(tkhd.matrix!, Matrix.rotate0)
            XCTAssertEqual(tkhd.matrix?.a, 1)
            XCTAssertEqual(tkhd.matrix?.b, 0)
            XCTAssertEqual(tkhd.matrix?.u, 0)
            XCTAssertEqual(tkhd.matrix?.c, 0)
            XCTAssertEqual(tkhd.matrix?.d, 1)
            XCTAssertEqual(tkhd.matrix?.v, 0)
            XCTAssertEqual(tkhd.matrix?.x, 0)
            XCTAssertEqual(tkhd.matrix?.y, 0)
            XCTAssertEqual(tkhd.size, 92)

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
        guard let path = path(forResource: "./Resources/ftyp") else {
            XCTFail("File not found.")
            return
        }
        let mp4 = try! MonolithicMP4FileParser(path: path).parse()
        guard let container = mp4.container as? ISO14496Part12Container else {
            XCTFail()
            return
        }
        let ftyp = container.ftyp
        let moov = container.moov
        let tmppath = temporaryFilePath()
        do {
            let w = ByteWriter(path: tmppath)
            var bytes = try ftyp.bytes()
            bytes += try moov.bytes()
            w.write(bytes)
            w.close()
            let url = URL(fileURLWithPath: tmppath)
            let data = Data(bytes: bytes)
            XCTAssertEqual(try Data(contentsOf: url), data)
        } catch {
            XCTFail("\(error)")
        }
        do {
            let mp4 = try MonolithicMP4FileParser(path: tmppath).parse()
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
