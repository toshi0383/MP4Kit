//
//  Error.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public enum BitStreamDecodeError: Error {
    case MissingKeyPath, TypeMismatch, Custom(String)
}
