//
//  Box.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public protocol BitStreamDecodable {
    static func decode(_ d: [UInt8]) throws -> Self
}

public enum BoxType: String {
    case ftyp
}

public protocol ByteFlags {
    var bytes: [Bool] {get}
}

public protocol Box {
    var size: UInt32 {get}
    var type: BoxType {get}
}

public protocol FullBox: Box {
    var version: UInt8 {get}
    var flags: ByteFlags {get}
}
