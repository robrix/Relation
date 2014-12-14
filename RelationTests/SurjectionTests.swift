//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Relation
import XCTest

final class SurjectionTests: XCTestCase {
	var surjection: Surjection<Int, Int>!

	override func setUp() {
		surjection = Surjection { $0 * $0 }
	}

	func testSubscriptingTheDomainInsertsValues() {
		XCTAssertNil(surjection.codomain[0])
		XCTAssertEqual(surjection.domain[0] ?? -1, 0)
		XCTAssertEqual(surjection.codomain[0] ?? -1, 0)
	}
}
