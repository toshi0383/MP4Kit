//
//  MetaBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class MetaBox: FullBoxBase {
    public var hdlr: HandlerBox!
    public override class func boxType() -> BoxType { return .meta }
    public required init() {
        super.init()
    }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        let hdlr = try HandlerBox(b)
        self.hdlr = hdlr
    }
    public override func bytes() throws -> [UInt8] {
        var bytes = try super.bytes()
        bytes += try hdlr.bytes()
        return bytes
    }
}
