//
//  BitStreamEncodableTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest

class BitStreamEncodableTests: XCTestCase {
    func testEncode() {
        XCTAssertEqual(try "ftyp".encode(), [102, 116, 121, 112])
        XCTAssertEqual(try "".encode(), [0, 0, 0, 0])
    }
}
