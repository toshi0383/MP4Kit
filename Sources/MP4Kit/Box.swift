//
//  Box.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public protocol BitStreamDecodable {
    init(_ b: ByteBuffer) throws
}

public protocol BitStreamEncodable {
    func encode() throws -> [UInt8]
    func reserve(_ size: Int) -> [UInt8]
}

extension BitStreamEncodable {
    public func reserve(_ size: Int) -> [UInt8] {
        return (0..<size).map{UInt8($0)}
    }
}

public enum BoxType: String, BitStreamEncodable {
    case ftyp, moov, trak
    case meta, mvhd, tkhd, uuid
    case mdat
    case boxbase, fullboxbase
    public func encode() throws -> [UInt8] {
        return try rawValue.encode()
    }
}

// MARK: - Box Protocols
public protocol Box: BitStreamDecodable, BitStreamEncodable {
    var size: UInt32 {get}
    var largesize: UInt64? {get}
    var type: BoxType {get}
    // `unsigned int(8)[16] usertype` is defined here in 14496-12,
    // but it should be implemented in `uuid` box independently.
    var usertype: [UInt8]? {get}
    static func boxType() -> BoxType
    init()
}

public protocol FullBox: Box {
    var version: UInt8 {get set}
    var flags: BitSet {get set}
}

// MARK: - Box Base Class
public class BoxBase: Box {
    public var size: UInt32 = 0 // Actual data is UInt32 unless it's defined as 'largesize'.
    public var type: BoxType = .boxbase
    public var largesize: UInt64? = nil
    public var usertype: [UInt8]? = nil
    public class func boxType() -> BoxType { return .boxbase }
    required public init(_ b: ByteBuffer) throws {
        self.size = b.next(4).uint32Value
        let strType = try b.next(4).stringValue()
        guard let type = BoxType(rawValue: strType) else {
            throw Error(problem: "Couldn't initialize BoxType with: \(strType)")
        }
        if self.size == 1 {
            self.largesize = b.next(8).uint64Value
        } else {
            self.largesize = nil
        }
        self.type = type
        if type == .uuid {
            self.usertype = b.next(16)
        } else {
            self.usertype = nil
        }
    }
    public required init() { }
    public func encode() throws -> [UInt8] {
        var bytes: [UInt8] = [
            try size.encode(),
            try type.encode()
        ].flatMap{$0}
        if let arr = try largesize?.encode() {
            bytes += arr
        }
        if let arr = usertype {
            bytes += arr
        }
        return bytes
    }
}

public class FullBoxBase: BoxBase, FullBox {
    public var version: UInt8 = 0
    public var flags: BitSet = BitSet(size: 24)
    public override class func boxType() -> BoxType { return .fullboxbase }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        guard let version = b.next(1).first else {
            throw Error(problem: "Couldn't parse \(self.type.rawValue).version")
        }
        self.version = version
        self.flags = BitSet(bytes: b.next(3))
    }

    public required init() {
        super.init()
    }
    public override func encode() throws -> [UInt8] {
        var bytes = try super.encode()
        bytes += [version]
        bytes += try flags.encode()
        return bytes
    }
}
