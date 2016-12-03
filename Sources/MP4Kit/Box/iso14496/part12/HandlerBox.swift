//
//  HandlerBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public enum HandlerType: String, BitStreamRepresentable {
    /// ObjectDescriptorStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case odsm
    /// ClockReferenceStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case crsm
    /// SceneDescriptionStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case sdsm
    /// MPEG7Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case m7sm
    /// ObjectContentInfoStream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case ocsm
    // IPMP Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case ipsm
    // MPEG-J Stream - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case mjsm
    // Apple Meta Data iTunes Reader
    case mdir
    // MPEG-7 binary XML
    case mp7b
    // MPEG-7 XML
    case mp7t
    // Video Track
    case vide
    // Sound Track
    case soun
    // Hint Track
    case hint
    // Apple specific
    case appl
    // Timed Metadata track - defined in ISO/IEC JTC1/SC29/WG11 - CODING OF MOVING PICTURES AND AUDIO
    case meta
    // when present in a meta box, contains an appropriate value to indicate the format of the meta box
    // contents. The value ‘null’ can be used in the primary meta box to indicate that it is merely 
    // being used to hold resources.

    case null

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
        guard let handlerType = HandlerType(rawValue: handlerTypeStr) else {
            throw Error(problem: "Unknown handlerType: \(handlerTypeStr)")
        }
        self.handlerType = handlerType
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
