//
//  main.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

guard ProcessInfo.processInfo.arguments.count > 1 else {
    fatalError("Filename parameter is missing")
}

let filename = ProcessInfo.processInfo.arguments[1]

func parseTest(_ filename: String) {
    let mp4 = try! MP4(path: filename)
    print(mp4)
    assert(mp4.container.ftyp.minorVersion == 512)
}

func inspect(_ filename: String) {
    let reader = ByteReader(filename: filename)
    guard let bytes = reader.next(size: 20) else {
        fatalError()
    }
    let format = "[%3d byte] %8x : %3c : %d"
    print("[num byte] Hex : CChar : Int")
    print("----------------------------")
    for (i, b) in bytes.enumerated() {
        if b == 0 {
            // zero byte
            print("\(String(format: format, arguments: [i + 1, b, b, b]))")
        } else {
            print("\(String(format: format, arguments: [i + 1, b, b, b]))")
        }
    }
}

parseTest(filename)
