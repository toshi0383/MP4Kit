//
//  MovieHeaderBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/22.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class MovieHeaderBox: FullBoxBase {
    public var creationTime: Date = Constants.referenceDate
    public var modificationTime: Date = Constants.referenceDate
    public var timescale: UInt32 = 0
    public var duration: UInt64 = 0
    public var rate: Double? = nil
    public var volume: Float? = nil
    public var matrix: Matrix? = nil
    public var nextTrackID: UInt32 = 0
    public override class func boxType() -> BoxType { return .mvhd }

    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.creationTime = Date(sinceReferenceDate: version == 1 ?
            b.next(8).uint64Value : UInt64(b.next(4).uint32Value))
        self.modificationTime = Date(sinceReferenceDate: version == 1 ?
            b.next(8).uint64Value : UInt64(b.next(4).uint32Value))
        self.timescale = b.next(4).uint32Value
        self.duration = version == 1 ? b.next(8).uint64Value : UInt64(b.next(4).uint32Value)
        self.rate = b.next(4).double1616Value
        self.volume = b.next(2).float88Value
        b.next(2) // reserved
        b.next(4); b.next(4) // reserved
        self.matrix = try Matrix(b)
        b.next(24) // predefined
        self.nextTrackID = b.next(4).uint32Value
    }
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        if version == 1 {
            bytes += try creationTime.uint64Value.bytes()
            bytes += try modificationTime.uint64Value.bytes()
            bytes += try timescale.bytes()
            bytes += try duration.bytes()
        } else {
            bytes += try creationTime.uint32Value.bytes()
            bytes += try modificationTime.uint32Value.bytes()
            bytes += try timescale.bytes()
            bytes += try UInt32(duration).bytes()
        }
        if let rate = rate {
            bytes += try rate.double1616ToUInt32().bytes()
        }
        if let volume = volume {
            bytes += try volume.float88ToUInt16().bytes()
        }
        bytes += reserve(2) // reserved
        bytes += reserve(4) // reserved
        bytes += reserve(4) // reserved
        if let matrix = matrix {
            bytes += try matrix.bytes()
        }
        bytes += reserve(24) // predefined
        bytes += try nextTrackID.bytes()
        return bytes
    }
}
