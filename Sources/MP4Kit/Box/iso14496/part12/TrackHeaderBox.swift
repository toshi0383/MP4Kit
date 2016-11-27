//
//  TrackHeaderBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/26.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class TrackHeaderBox: FullBoxBase {
    public var creationTime: Date = Constants.referenceDate
    public var modificationTime: Date = Constants.referenceDate
    public var trackID: UInt32 = 0
    public var duration: UInt64 = 0

    public var layer: UInt16? = nil
    public var alternateGroup: UInt16? = nil
    public var volume: Float? = nil
    public var matrix: Matrix? = nil
    public var width: Double = 0
    public var height: Double = 0
    public override class func boxType() -> BoxType { return .tkhd }

    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.creationTime = Date(sinceReferenceDate: version == 1 ?
            b.next(8).uint64Value : UInt64(b.next(4).uint32Value))
        self.modificationTime = Date(sinceReferenceDate: version == 1 ?
            b.next(8).uint64Value : UInt64(b.next(4).uint32Value))
        self.trackID = b.next(4).uint32Value
        b.next(4) // reserved
        self.duration = version == 1 ? b.next(8).uint64Value : UInt64(b.next(4).uint32Value)
        b.next(4); b.next(4) // reserved
        self.layer = b.next(2).uint16Value
        self.alternateGroup = b.next(2).uint16Value
        self.volume = b.next(2).float88Value
        b.next(2) // reserved
        self.matrix = try Matrix(b)
        self.width = b.next(4).double1616Value
        self.height = b.next(4).double1616Value
    }
}
