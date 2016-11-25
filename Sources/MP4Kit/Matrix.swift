//
//  Matrix.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/22.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public class Matrix: BitStreamDecodable {
    public static let rotate0   = Matrix(a: 1, b: 0, c: 0, d: 1, u: 0, v: 0, w: 1, x: 0, y: 0)
    public static let rotate90  = Matrix(a: 0, b: 1, c: -1, d: 0, u: 0, v: 0, w: 1, x: 0, y: 0)
    public static let rotate180 = Matrix(a: -1, b: 0, c: 0, d: -1, u: 0, v: 0, w: 1, x: 0, y: 0)
    public static let rotate270 = Matrix(a: 0, b: -1, c: 1, d: 0, u: 0, v: 0, w: 1, x: 0, y: 0)

    public let u, v, w: Double
    public let a, b, c, d, x, y: Double

    // swiftlint:disable:next function_parameter_count
    public init(a: Double, b: Double, c: Double, d: Double,
         u: Double, v: Double, w: Double, x: Double, y: Double) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.u = u
        self.v = v
        self.w = w
        self.x = x
        self.y = y
    }
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

extension Matrix: Equatable {
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        return (
            lhs.a == rhs.a &&
            lhs.b == rhs.b &&
            lhs.c == rhs.c &&
            lhs.d == rhs.d &&
            lhs.u == rhs.u &&
            lhs.v == rhs.v &&
            lhs.w == rhs.w &&
            lhs.x == rhs.x &&
            lhs.y == rhs.y
        )
    }
}
