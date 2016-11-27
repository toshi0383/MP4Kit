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

public protocol BitStreamRepresentable {
    func bytes() throws -> [UInt8]
}

func reserve(_ size: Int) -> [UInt8] {
    return (0..<size).map{UInt8($0)}
}

public enum BoxType: String, BitStreamRepresentable {
    case ftyp, moov, trak
    case meta, mvhd, tkhd, uuid
    case mdat
    case boxbase, fullboxbase
    public func bytes() throws -> [UInt8] {
        return try rawValue.bytes()
    }
}

// MARK: - Box Protocols
public protocol Box: BitStreamDecodable, BitStreamRepresentable {
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
    public func bytes() throws -> [UInt8] {
        var bytes: [UInt8] = [
            try size.bytes(),
            try type.bytes()
        ].flatMap{$0}
        if let arr = try largesize?.bytes() {
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
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        bytes += [version]
        bytes += try flags.bytes()
        return bytes
    }
}
