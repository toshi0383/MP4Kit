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

public enum BoxType: String {
    case ftyp, moov, mvhd, uuid
    case mdat
    case boxbase, fullboxbase
}

public struct ByteFlags {
    public let value: [Bool]
    init?(bytes: [UInt8]) {
        guard bytes.count == 3 else { // Assume 24 bit
            return nil
        }
        self.value = bytes.map{String.init($0, radix: 2)}
            .joined()
            .characters
            .map{$0 == "0"}
    }
}

// MARK: - Box Protocols
public protocol Box: BitStreamDecodable {
    var size: UInt32 {get}
    var largesize: UInt64? {get}
    var type: BoxType {get}
    // `unsigned int(8)[16] usertype` is defined here in 14496-12,
    // but it should be implemented in `uuid` box independently.
    var usertype: [UInt8]? {get}
    static func boxType() -> BoxType
}

public protocol FullBox: Box {
    var version: UInt8! {get set}
    var flags: ByteFlags! {get set}
}

// MARK: - Box Base Class
public class BoxBase: Box {
    public let size: UInt32 // Actual data is UInt32 unless it's defined as 'largesize'.
    public let largesize: UInt64?
    public let type: BoxType
    public let usertype: [UInt8]?
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
}

public class FullBoxBase: BoxBase, FullBox {
    public var version: UInt8!
    public var flags: ByteFlags! // Actual data is bit(24)
    public override class func boxType() -> BoxType { return .fullboxbase }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        guard let version = b.next(1).first else {
            throw Error(problem: "Couldn't parse \(self.type.rawValue).version")
        }
        self.version = version
        self.flags = ByteFlags(bytes: b.next(3))!
    }
}
