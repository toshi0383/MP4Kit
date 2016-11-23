//
//  ByteBuffer.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/23.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public class ByteBuffer {

    private let bytes: [UInt8]
    private var _position: Int = 0

    public var endIndex: Int {
        return bytes.count
    }

    public var position: Int {
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

    public init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    @discardableResult
    public func next(_ byteCount: Int) -> [UInt8] {
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

    public func seek(_ byteCount: Int) {
        if byteCount < 0 {
            position += byteCount
        } else {
            next(byteCount)
        }
    }

    public func nextBoxBytes() throws -> [UInt8] {
        let (size, boxtype) = try decodeBoxHeader(next(8))
        seek(-8)
        if boxtype == nil {
            throw Error(problem: "Couldn't find next Box.", problemByteOffset: position-8)
        } else {
            return next(Int(size))
        }
    }

    public func rewind() {
        self.position = 0
    }
}
