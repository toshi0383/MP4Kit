//
//  Error.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public struct Error: Swift.Error {
    let problem: String
    let problemByteOffset: Int
    init(problem: String, problemByteOffset: Int = 0) {
        self.problem = problem
        self.problemByteOffset = problemByteOffset
    }
}
