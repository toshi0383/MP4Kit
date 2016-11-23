//
//  FileTypeBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public final class FileTypeBox: BoxBase {
    public var majorBrand: String = ""
    public var minorVersion: UInt32 = 0
    public var compatibleBrands: [String] = []
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.majorBrand = try b.next(4).stringValue()
        self.minorVersion = b.next(4).uint32Value
        let brandsStr: String = try b.next(b.endIndex).stringValue()
        self.compatibleBrands = brandsStr.slice(4)
    }
}
