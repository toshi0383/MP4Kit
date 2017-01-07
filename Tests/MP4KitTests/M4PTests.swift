//
//  M4PTests.swift
//  MP4Kit
//
//  Created by toshi0383 on 2017/01/07.
//  Copyright © 2017 Toshihiro Suzuki. All rights reserved.
//

import XCTest
@testable import MP4Kit

class M4PTests: XCTestCase {

    func testM4P() {
        let p = path(forResource: "./Resources/fromapplemusic.m4p")!
        let parser = IntermediateBoxParser(path: p)
        do {
            let mp4 = try parser.parse{$0 == .mdat}
            guard let container = mp4.container as? IntermediateBoxContainer else {
                XCTFail()
                return
            }
            XCTAssertEqual(container.boxes.count, 3)
            print(container.boxes)
        } catch {
            XCTFail("\(error)")
        }
    }
}
