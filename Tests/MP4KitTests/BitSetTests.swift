//
//  BitSetTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class BitSetTests: XCTestCase {
    func testBitSet() {
        let bytes: [UInt8] = [UInt8(UINT8_MAX), 0, 0]
        var expected = BitSet(size: 24)
        expected[0] = true
        expected[1] = true
        expected[2] = true
        expected[3] = true
        expected[4] = true
        expected[5] = true
        expected[6] = true
        expected[7] = true
        XCTAssertEqual(BitSet(bytes: bytes), expected)
        XCTAssertEqual(try! BitSet(bytes: bytes).bytes(), [255, 0, 0])
    }
    func testBitSetAllOne() {
        let bytes: [UInt8] = (0..<3).map{_ in UInt8(UINT8_MAX)}
        var expected = BitSet(size: 24)
        for i in (0..<24) {
            expected[i] = true
        }
        XCTAssertEqual(BitSet(bytes: bytes), expected)
        XCTAssertEqual(try! BitSet(bytes: bytes).bytes(), [255, 255, 255])
    }
    static var allTests: [(String, (BitSetTests) -> () throws -> Void)] {
        return [
            ("testBitSet", testBitSet),
            ("testBitSetAllOne", testBitSetAllOne),
        ]
    }
}
