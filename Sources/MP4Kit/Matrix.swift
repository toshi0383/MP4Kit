//
//  Matrix.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/22.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public class Matrix: BitStreamDecodable {
    public let u, v, w: Double
    public let a, b, c, d, x, y: Double
    required public init(_ b: ByteBuffer) throws {
        self.a = b.next(4).double1616Value
        self.b = b.next(4).double1616Value
        self.u = b.next(4).double0230Value
        self.c = b.next(4).double1616Value
        self.d = b.next(4).double1616Value
        self.v = b.next(4).double0230Value
        self.x = b.next(4).double1616Value
        self.y = b.next(4).double1616Value
        self.w = b.next(4).double0230Value
    }
}
