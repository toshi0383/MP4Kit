//
//  MovieHeaderBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/22.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class MovieHeaderBox: FullBoxBase {
    public var creationTime: UInt64 = 0
    public var modificationTime: UInt64 = 0
    public var timescale: UInt32 = 0
    public var duration: UInt64 = 0
    public var rate: Double? = nil
    public var volume: Float? = nil
    public var reserved: UInt16 = 0
    public var reserved2: [UInt32] = []
    public var matrix: Matrix? = nil
    public var preDefined: [UInt32] = []
    public var nextTrackID: UInt32 = 0

    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.creationTime = version == 1 ? b.next(8).uint64Value : UInt64(b.next(4).uint32Value)
        self.modificationTime = version == 1 ? b.next(8).uint64Value : UInt64(b.next(4).uint32Value)
        self.timescale = b.next(4).uint32Value
        self.duration = version == 1 ? b.next(8).uint64Value : UInt64(b.next(4).uint32Value)
        self.rate = b.next(4).double1616Value
        self.volume = b.next(2).float88Value
        self.reserved = b.next(2).uint16Value
        self.reserved2 = [b.next(4).uint32Value, b.next(4).uint32Value]
        self.matrix = try Matrix(b)
        self.preDefined = [
            b.next(4).uint32Value,
            b.next(4).uint32Value,
            b.next(4).uint32Value,
            b.next(4).uint32Value,
            b.next(4).uint32Value,
            b.next(4).uint32Value,
        ]
        self.nextTrackID = b.next(4).uint32Value
    }
}
