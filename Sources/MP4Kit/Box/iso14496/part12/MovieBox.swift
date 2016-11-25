//
//  MovieBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/14.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class MovieBox: BoxBase {
    public var mvhd: MovieHeaderBox!
    public override class func boxType() -> BoxType { return .moov }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.mvhd = try? decodeBox(try b.nextBoxBytes())
    }
}
