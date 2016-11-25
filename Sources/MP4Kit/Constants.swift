//
//  Constants.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/25.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

struct Constants {
    static let referenceDate: Date = {
        let cal = Calendar(identifier: .gregorian)
        let c = DateComponents(calendar: cal,
            timeZone: TimeZone(abbreviation: "UTC"),
            year: 1904, month: 1, day: 1, hour: 0, minute: 0, second: 0
        )
        return c.date!
    }()
}
