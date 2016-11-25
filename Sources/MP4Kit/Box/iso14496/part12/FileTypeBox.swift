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
    public override class func boxType() -> BoxType { return .ftyp }
    required public init(_ b: ByteBuffer) throws {
        try super.init(b)
        self.majorBrand = try b.next(4).stringValue()
        self.minorVersion = b.next(4).uint32Value
        let brandsStr: String = try b.next(b.endIndex).stringValue()
        self.compatibleBrands = brandsStr.slice(4)
    }
    public required init() {
        super.init()
    }
    public override func encode() throws -> [UInt8] {
        var bytes = try super.encode()
        bytes += try majorBrand.encode()
        bytes += try minorVersion.encode()
        bytes += try compatibleBrands.map{try $0.encode()}.flatMap{$0}
        return bytes
    }
}
