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
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        let mvhd: MovieHeaderBox = try decodeBox(try b.nextBoxBytes())
        self.mvhd = mvhd
    }
}
