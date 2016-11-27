//
//  ByteBuffer.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/23.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

/// ByteBuffer
/// - Note: Marked public because this class is used as a parameter 
///     for the initializer of public Box protocol.
public class ByteBuffer {

    private let bytes: [UInt8]
    private var _position: Int = 0

    var endIndex: Int {
        return bytes.count
    }

    var position: Int {
        get {
            return _position
        }
        set(newValue) {
            if newValue >= self.bytes.count {
                _position = self.bytes.count - 1
            } else {
                _position = newValue
            }
        }
    }

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    @discardableResult
    func next(_ byteCount: Int) -> [UInt8] {
        guard position != self.bytes.count else {
            return []
        }
        var nextPosition = position + byteCount
        if nextPosition >= self.bytes.count {
            nextPosition = self.endIndex
        }
        let bytes = self.bytes[position..<nextPosition].map{$0}
        self.position = nextPosition
        return bytes
    }

    func seek(_ byteCount: Int) {
        if byteCount < 0 {
            position += byteCount
        } else {
            next(byteCount)
        }
    }

    func hasNext() -> Bool {
        return bytes.count > position + 1
    }

    func nextBoxBytes() throws -> [UInt8] {
        let (size, boxtype) = try decodeBoxHeader(next(16))
        seek(-16)
        if boxtype == nil {
            throw Error(problem: "Couldn't find next Box.", problemByteOffset: position-8)
        } else {
            // `size` is UInt64 here, so assuming not to load so much bytes on memory.
            // Let's ignore if it overflows.
            // Swift.Array.count is Int and it crashes on overflow, too.
            // Let's put it that way for now..
            return next(Int(size))
        }
    }

    func rewind() {
        self.position = 0
    }
}
