//
//  HandlerBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class HandlerBox: BoxBase {
    public override class func boxType() -> BoxType { return .hdlr }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
    }
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        return bytes
    }
}
