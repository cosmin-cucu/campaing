//
//  campaINGTests.swift
//  campaINGTests
//
//  Created by Cosmin Cucu on 18/8/24.
//

import XCTest
@testable import campaING

final class BuilderTableViewControllerTests: XCTestCase {

    func testConfigurationSetup() throws {
        let configuration = BuilderTableViewConfiguration(.chooseTargetingSpecifics)
        let vc = BuilderTableViewController<TargetingSpecific>(nibName: nil, bundle: nil)
        
        XCTAssertEqual(vc.navigationItem.title, configuration.title)
    }
}
