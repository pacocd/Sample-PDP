//
//  MainTests.swift
//  PDPTests
//
//  Created by Francisco Javier Chacon de Dios on 11/01/18.
//  Copyright © 2018 Paco Chacon de Dios. All rights reserved.
//

import XCTest
@testable import PDP

class MainTests: XCTestCase {

    var productListViewController: ProductsListViewController = ProductsListViewController()

    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Products", bundle: nil)
        productListViewController = storyboard.instantiateViewController(withIdentifier: "ProductsListViewController") as! ProductsListViewController
        _ = productListViewController.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRendersProperlyShouldBeTrue() {
        XCTAssertNotNil(productListViewController)
        XCTAssertNotNil(productListViewController.addProductButton)
    }

}
