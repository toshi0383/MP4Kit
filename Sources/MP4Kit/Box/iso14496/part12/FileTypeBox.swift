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
        self.majorBrand = try extract(b.next(4))
        self.minorVersion = b.next(4).uint32Value
        let brandsStr: String = try extract(b.next(b.endIndex))
        self.compatibleBrands = brandsStr.slice(4)
    }
}
