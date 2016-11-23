//
//  MP4.swift
//  MP4Kit
//
//  Created by toshi0383 on 2016/11/13.
//  Copyright © 2016 Toshihiro Suzuki. All rights reserved.
//

import Foundation

public struct MP4 {
    public let container: MediaContainer
}

// MARK: - Containers
public protocol MediaContainer {}
public struct ISO14496Part12Container: MediaContainer {
    public let ftyp: FileTypeBox
    public let moov: MovieBox
    public let mdat: MediaDataBox?
}
