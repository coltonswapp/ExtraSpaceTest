//
//  AlbumControllerTest.swift
//  ExtraSpaceTestTests
//
//  Created by Colton Swapp on 8/24/21.
//
@testable import ExtraSpaceTest
import XCTest

class AlbumControllerTest: XCTestCase {

    func test_urlConstruction_shouldReturnSomething() {
        
        let result = AlbumController.shared.constructURL(start: 0, limit: 10)
        
        XCTAssertEqual(result, URL(string: "https://jsonplaceholder.typicode.com/photos?_start=0&_limit=10"))
        
    }

}
