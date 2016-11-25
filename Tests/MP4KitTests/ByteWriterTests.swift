//
//  ByteWriterTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import XCTest
import Foundation
@testable import MP4Kit

private var tmpCounter = 0
func temporaryFilePath() -> String {
    let url = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    tmpCounter += 1
    return url.appendingPathComponent("tmp\(tmpCounter)").path
}

class ByteWriterTests: XCTestCase {

    func testByteWriter() {
        let bytes: [UInt8] = [255, 0, 0, 0]
        let path = temporaryFilePath()
        let w = ByteWriter(path: path)
        w.write(bytes)
        w.close()
        XCTAssertEqual(Data(bytes: bytes), try! Data(contentsOf: URL(fileURLWithPath: path)))
    }

    static var allTests: [(String, (ByteWriterTests) -> () throws -> Void)] {
        return [
            ("testByteWriter", testByteWriter),
        ]
    }
}
