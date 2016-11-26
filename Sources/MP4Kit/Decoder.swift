//
//  Decoder.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

// MARK: - Decode Byte Array
func decodeBox<T: BitStreamDecodable>(_ bytes: [UInt8]) throws -> T {
    return try T(ByteBuffer(bytes: bytes))
}

func decodeBox<T: BitStreamDecodable>(_ data: Data) throws -> T {
    let array = data.withUnsafeBytes {
        [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
    }
    return try T(ByteBuffer(bytes: array))
}

func decodeBoxHeader(_ bytes: [UInt8]) throws -> (UInt64, BoxType?) {
    let size = bytes[0..<4].map{$0}.uint32Value
    let boxbytes = bytes[4..<8].map{$0}
    let boxtype = try boxbytes.stringValue()
    print(boxtype)
    if size == 1 {
        let largesize = bytes[8..<16].map{$0}.uint64Value
        return (largesize, BoxType(rawValue: boxtype))
    } else {
        return (UInt64(size), BoxType(rawValue: boxtype))
    }
}

func decodeBoxHeader(_ data: Data) throws -> (UInt64, BoxType?) {
    return try decodeBoxHeader(data[0..<16].map{$0})
}

// MARK: - Parse IntermediateBox
protocol _IntermediateBox {
    var size: UInt64 {get}
    var type: BoxType {get}
    var bytes: [UInt8] {get}
}
extension IntermediateBox: _IntermediateBox {}

infix operator <-
func <-<T: _IntermediateBox, R: Box>(array: [T], type: R.Type) throws -> R {
    return (try array.parse(type: type)).first!
}
infix operator <-?
func <-?<T: _IntermediateBox, R: Box>(array: [T], type: R.Type) throws -> R? {
    return (try? array.parse(type: type))?.first
}
infix operator <-|
func <-|<T: _IntermediateBox, R: Box>(array: [T], type: R.Type) throws -> [R] {
    return try array.parse(type: type)
}

extension Array where Element: _IntermediateBox {
    fileprivate func parse<R: Box>(type: R.Type) throws -> [R] {
        let decoded = try self.flatMap {
            (box: Element) throws -> R? in
            if box.type == R.boxType() {
                return try? decodeBox(box.bytes)
            } else {
                return nil
            }
        }
        guard decoded.count > 0 else {
            throw Error(problem: "Couldn't find the box of type \(type) in \(self)")
        }
        return decoded
    }
}
