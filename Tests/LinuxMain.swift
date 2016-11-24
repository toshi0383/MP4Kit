import XCTest
@testable import MP4KitTests

XCTMain([
     testCase(ByteReaderTests.allTests),
     testCase(LargeSizeTests.allTests),
     testCase(MP4KitTests.allTests),
])
