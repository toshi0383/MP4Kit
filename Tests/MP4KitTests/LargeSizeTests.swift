//
//  LargeSizeTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/24.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class LargeSizeTests: XCTestCase {

    func testLargeSize() {
        let bytes: [UInt8] = [
            0x00, 0x00, 0x00, 0x01, // size: 1
            0x6d, 0x64, 0x61, 0x74, // type: mdat
            0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, // largesize: UINT64_MAX
        ]
        let typebytes = bytes[4..<8].map{$0}
        XCTAssertEqual(try typebytes.stringValue(), "mdat")
        XCTAssertEqual(bytes[8..<16].map{$0}.uint64Value, UINT64_MAX)
        do {
            let (size, type) = try decodeBoxHeader(bytes)
            XCTAssertEqual(size, UINT64_MAX)
            XCTAssertEqual(type!, .mdat)
        } catch {
            XCTFail("\(error)")
        }
    }
    static var allTests: [(String, (LargeSizeTests) -> () throws -> Void)] {
        return [
            ("testLargeSize", testLargeSize),
        ]
    }
}
