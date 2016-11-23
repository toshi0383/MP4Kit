//
//  Decoder.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public func decodeBox<T: BitStreamDecodable>(_ bytes: [UInt8]) throws -> T {
    return try T(ByteBuffer(bytes: bytes))
}

public func decodeBox<T: BitStreamDecodable>(_ data: Data) throws -> T {
    let array = data.withUnsafeBytes {
        [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
    }
    return try T(ByteBuffer(bytes: array))
}

func decodeBoxHeader(_ bytes: [UInt8]) throws -> (UInt32, BoxType?) {
    let size = bytes[0..<4].map{$0}.uint32Value
    let boxbytes = bytes[4..<8].map{$0}
    let boxtype = try boxbytes.stringValue()
    print(boxtype)
    return (size, BoxType(rawValue: boxtype))
}

func decodeBoxHeader(_ data: Data) throws -> (UInt32, BoxType?) {
    return try decodeBoxHeader(data[0..<8].map{$0})
}
