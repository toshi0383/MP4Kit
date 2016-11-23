//
//  ByteReader.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

internal struct Constants {
    static let bufferSize: Int = 36
}

class ByteReader {
    private let fp: UnsafeMutablePointer<FILE>
    init(path: String) {
        self.fp = fopen(path, "rb")
    }
    @discardableResult
    func next(size: Int) -> [UInt8] {
        var buf = Array<UInt8>(repeating: 0, count: size)
        fread(&buf, 1, size, fp)
        return buf
    }
    func data(size: Int) -> Data {
        return Data(bytes: next(size: size))
    }
    func hasNext() -> Bool {
        return feof(fp) == 0
    }
    func rewind() {
        fseek(fp, 0, SEEK_SET)
    }
    func seek(_ amount: Int) {
        fseek(fp, amount, SEEK_CUR)
    }
    deinit {
        fclose(fp)
    }
}

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
            throw Error(problem: "Couldn't find next Box.")
        } else {
            return next(Int(size))
        }
    }

    public func rewind() {
        self.position = 0
    }
}
