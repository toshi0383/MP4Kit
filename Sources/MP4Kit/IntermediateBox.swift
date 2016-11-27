//
//  IntermediateBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/23.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

final class IntermediateBox {
    let size: UInt64
    let type: BoxType
    let bytes: [UInt8]
    init(bytes: [UInt8]) throws {
        self.bytes = bytes
        guard let (size, type) = try? decodeBoxHeader(bytes) else {
            throw Error(problem: "Couldn't parse size or type.")
        }
        guard let t = type else {
            throw Error(problem: "Unknown box type in \(type(of: self)).")
        }
        self.size = UInt64(size)
        self.type = t
    }
}
