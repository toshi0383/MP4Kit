//
//  MovieHeaderBoxTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class MovieHeaderBoxTests: XCTestCase {

    func testEncodeDecode() {
        XCTAssertEqual(try! UInt32(1).encode(), [0, 0, 0, 1])
        let mvhd = MovieHeaderBox()
        mvhd.size = 108
        mvhd.type = .mvhd
        mvhd.rate = 1.0
        mvhd.creationTime = Date(sinceReferenceDate: 3)
        mvhd.modificationTime = Date(sinceReferenceDate: 5)
        mvhd.timescale = 255
        mvhd.duration = 128
        mvhd.rate = 1.0
        mvhd.volume = 1.0
        mvhd.matrix = .rotate0
        mvhd.nextTrackID = 64
        do {
            let bytes = try mvhd.encode()
            let result = try MovieHeaderBox(ByteBuffer(bytes: bytes)).encode()
            XCTAssertEqual(bytes, result)
        } catch {
            XCTFail("\(error)")
        }
    }
    static var allTests: [(String, (MovieHeaderBoxTests) -> () throws -> Void)] {
        return [
            ("testEncodeDecode", testEncodeDecode),
        ]
    }
}
