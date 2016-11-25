//
//  SharedFunctionality.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

func path(forResource name: String) -> String? {
    #if SWIFT_PACKAGE
        return name
    #else
        return Bundle(for: MP4KitTests.self)
            .path(forResource: name.components(separatedBy: "/").last!, ofType: nil)
    #endif
}

private var tmpCounter = 0
func temporaryFilePath() -> String {
    let url = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    tmpCounter += 1
    return url.appendingPathComponent("tmp\(tmpCounter)").path
}
