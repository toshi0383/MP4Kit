//
//  FileTypeBox.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public struct FileTypeBox: Box, BitStreamDecodable {
    public let size: UInt32
    public let type = BoxType.ftyp
    public let majorBrand: String
    public let minorVersion: UInt32
    public let compatibleBrands: [String]
    init(size: UInt32, majorBrand: String,
        minorVersion: UInt32, compatibleBrands: [String])
    {
        self.size = size
        self.majorBrand = majorBrand
        self.minorVersion = minorVersion
        self.compatibleBrands = compatibleBrands
    }
    public static func decode(_ d: [UInt8]) throws -> FileTypeBox {
        let brandsStr: String = try extract(d[16..<d.endIndex].map{$0})
        return FileTypeBox(
            size: d[0..<4].map{$0}.uint32Value,
            majorBrand: try extract(d[8..<12].map{$0}),
            minorVersion: d[12..<16].map{$0}.uint32Value,
            compatibleBrands: brandsStr.slice(4)
        )
    }
}
