import XCTest
@testable import MP4KitTests

XCTMain([
     testCase(MP4KitTests.allTests),
     testCase(ByteReaderTests.allTests),
     testCase(LargeSizeTests.allTests),
])
