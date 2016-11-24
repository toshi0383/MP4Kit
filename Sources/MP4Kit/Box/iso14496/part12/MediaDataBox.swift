//
//  MediaDataBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/23.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public class MediaDataBox: BoxBase {
    public var data: [UInt8] = []
    public override class func boxType() -> BoxType { return .mdat }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.data = b.next(b.endIndex-b.position)
    }
}
