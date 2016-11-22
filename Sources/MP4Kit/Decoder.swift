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

func decodeBoxHeader(_ data: [UInt8]) throws -> (UInt32, BoxType?) {
    let size = data[0..<4].map{$0}.uint32Value
    guard let boxtype: String = try? extract(data[4..<8].map{$0}) else {
        throw Error(problem: "Failed to parse string from: \(data[4..<8])")
    }
    return (size, BoxType(rawValue: boxtype))
}

func decodeBoxHeader(_ data: Data) throws -> (UInt32, BoxType?) {
    let size = data[0..<4].map{$0}.uint32Value
    guard let boxtype: String = try? extract(data[4..<8].map{$0}) else {
        throw Error(problem: "Failed to parse string from: \(data[4..<8])")
    }
    print(boxtype)
    return (size, BoxType(rawValue: boxtype))
}

func extract(_ data: Data) throws -> UInt32 {
    return data.withUnsafeBytes{$0.pointee}
}

func extract(_ bytes: [UInt8]) throws -> String {
    return try extract(Data(bytes: bytes))
}

func extract(_ data: Data) throws -> String {
    guard let str = String(data: data, encoding: String.Encoding.utf8) else {
        throw Error(problem: "String parse error!: \(data)")
    }
    return str
}
