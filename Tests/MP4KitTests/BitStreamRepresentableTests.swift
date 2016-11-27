//
//  BitStreamRepresentableTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class BitStreamRepresentableTests: XCTestCase {
    func testBytes() {
        XCTAssertEqual(try "ftyp".bytes(), [102, 116, 121, 112])
        XCTAssertEqual(try "".bytes(), [0, 0, 0, 0])
        XCTAssertEqual(reserve(4), [0, 0, 0, 0])
    }
    static var allTests: [(String, (BitStreamRepresentableTests) -> () throws -> Void)] {
        return [
            ("testBytes", testBytes),
        ]
    }
}
