//
//  HandlerBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public struct HandlerType: RawRepresentable, BitStreamRepresentable {
    /// ObjectDescriptorStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let odsm = HandlerType(rawValue: "odsm")
    /// ClockReferenceStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let crsm = HandlerType(rawValue: "crsm")
    /// SceneDescriptionStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let sdsm = HandlerType(rawValue: "sdsm")
    /// MPEG7Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let m7sm = HandlerType(rawValue: "m7sm")
    /// ObjectContentInfoStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let ocsm = HandlerType(rawValue: "ocsm")
    // IPMP Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let ipsm = HandlerType(rawValue: "ipsm")
    // MPEG-J Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let mjsm = HandlerType(rawValue: "mjsm")
    // Apple Meta Data iTunes Reader
    public static let mdir = HandlerType(rawValue: "mdir")
    // MPEG-7 binary XML
    public static let mp7b = HandlerType(rawValue: "mp7b")
    // MPEG-7 XML
    public static let mp7t = HandlerType(rawValue: "mp7t")
    // Video Track
    public static let vide = HandlerType(rawValue: "vide")
    // Sound Track
    public static let soun = HandlerType(rawValue: "soun")
    // Hint Track
    public static let hint = HandlerType(rawValue: "hint")
    // Apple specific
    public static let appl = HandlerType(rawValue: "appl")
    // Timed Metadata track - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    public static let meta = HandlerType(rawValue: "meta")

    // Quote from ISO/IEC 14496 Part12
    // 'when present in a meta box, contains an appropriate value to indicate the format of the meta box
    // contents. The value ‘null’ can be used in the primary meta box to indicate that it is merely 
    // being used to hold resources.'
    public static let null = HandlerType(rawValue: "null")

    public var rawValue: String

    /// There may exists unknown new custom HandlerType in the world.
    /// Let's be friendly here.
    /// - parameter rawValue:
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: BitStreamRepresentable
    public func bytes() throws -> [UInt8] {
        return try rawValue.bytes()
    }
}

public final class HandlerBox: FullBoxBase {
    public var handlerType: HandlerType = .null
    public var name: String = ""
    public override class func boxType() -> BoxType { return .hdlr }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        b.next(4) // pre_defined
        let handlerTypeStr = try b.next(4).stringValue()
        self.handlerType = HandlerType(rawValue: handlerTypeStr)
        b.next(3) // reserved
        self.name = try b.next(b.endIndex-b.position).stringValue()
    }
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        bytes += reserve(4)
        bytes += try self.handlerType.bytes()
        bytes += reserve(3)
        bytes += try self.name.bytes()
        return bytes
    }
}
