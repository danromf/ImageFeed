import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false 
        app.launch()
    }
    
    func testAuth() throws {
        print(app.debugDescription)
        app.buttons["Authenticate"].tap()
            
        let webView = app.webViews["UnsplashWebView"]
            
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
            
        loginTextField.tap()
        loginTextField.typeText("dan.romanoff15@gmail.com")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        webView.swipeUp()
            
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
            
        passwordTextField.tap()
        
        passwordTextField.typeText("qipriB-navcew-3fedxi")
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        webView.swipeUp()
            
        webView.buttons["Login"].tap()
            
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(5)
        let tablesQuery = app.tables
        sleep(5)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
            
        sleep(3)
            
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
            
        sleep(3)
        cellToLike.buttons["likeButton"].tap()
        sleep(3)
        cellToLike.buttons["likeButton"].tap()
            
        sleep(3)
            
        cellToLike.tap()
            
        sleep(3)
            
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
            
        let navBackButtonWhiteButton = app.buttons["Backward"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
                
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["Dan Romanov"].exists)
        XCTAssertTrue(app.staticTexts["@dromanoff"].exists)
        
        app.buttons["logoutButton"].tap()
        
        sleep(5)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(5)
    }
}
