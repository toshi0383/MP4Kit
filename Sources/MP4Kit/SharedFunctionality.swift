//
//  SharedFunctionality.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/27.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

/// Returns a byte array.
/// Use this function to get reserved size of bytes to write BitStream.
/// - parameter size: Number of Bytes
/// - returns: [UInt8] 0 filled UInt8 array.
func reserve(_ size: Int) -> [UInt8] {
    return (0..<size).map{_ in UInt8(0)}
}
