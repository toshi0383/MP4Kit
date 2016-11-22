//
//  ByteReaderTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/22.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class ByteReaderTests: XCTestCase {
    func testSeekAndRead() {
        guard let path = path(forResource: "ftyp") else {
            XCTFail()
            return
        }
        let r = ByteReader(path: path)
        XCTAssert(r.hasNext())
        XCTAssertEqual(r.next(size: 1)[0], 0) // 1
        r.seek(-1) // 0
        r.seek(36) // 36
        XCTAssertEqual(r.next(size: 4).uint32Value, 228961) // 36-39
        r.seek(-1) // 0
        r.rewind() // 0
        XCTAssertEqual(r.next(size: 4).uint32Value, 36) // 4
        r.rewind() // 0
        r.seek(43200558)
        r.next(size: 1)
        XCTAssertFalse(r.hasNext())
        r.next(size: 1)
        XCTAssertFalse(r.hasNext())
    }
}
