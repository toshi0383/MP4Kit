//
//  TrackBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/26.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class TrackBox: BoxBase {
    public var tkhd: TrackHeaderBox!
    public override class func boxType() -> BoxType { return .trak }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        let tkhd: TrackHeaderBox = try decodeBox(try b.nextBoxBytes())
        self.tkhd = tkhd
    }
}
