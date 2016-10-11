
import XCTest

class UITestsPortrait: XCTestCase {

    override func setUp() {
        super.setUp()
        // make sure the device is in portrait orientation
        XCUIDevice.shared().orientation = .portrait
        XCUIApplication().launch()
        let app = XCUIApplication()
        // add a note
        let cells = app.tables.cells
        app.navigationBars["Note It"].buttons["Add"].tap()
        cells.element(boundBy: 0).tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Sample Note")
        app.textViews["noteText"].tap()
        app.textViews["noteText"].typeText("sample note details.")
        app.navigationBars["Sample Note"].buttons["Note It"].tap()
        continueAfterFailure = false
    }
    
    func testAddNote() {
        let app = XCUIApplication()
        // get a reference to the table cells
        let cells = app.tables.cells
        // there should be one cell added during setup
        XCTAssertEqual(cells.count, 1, "found instead: \(cells.debugDescription)")
        // add a new note.
        app.navigationBars["Note It"].buttons["Add"].tap()
        // now there should be two rows in the table.
        XCTAssertEqual(cells.count, 2, "found instead: \(cells.debugDescription)")
        XCTAssert(app.staticTexts["New Note"].exists)
        // tap on the first cell
        cells.element(boundBy: 1).tap()
        // make sure the keyboard is hidden
        XCTAssert(app.keyboards.count == 0, "The keyboard is shown")
        // select the title field
        let title = app.textFields["Title"]
        // select the field
        title.tap()
        // the keyboard is showing
        XCTAssert(app.keyboards.count > 0, "The keyboard is not shown")
        // click on the x to clear the text
        //title.buttons["Clear text"].tap()
        // type in the new title
        title.typeText("Lecture Notes")
        // select the note field
        app.textViews["noteText"].tap()
        app.textViews["noteText"].typeText("My lecture notes.")
        app.buttons["Done"].tap()
        // the keyboard is now hidden
        XCTAssert(app.keyboards.count == 0, "The keyboard is shown")
        app.buttons["Note It"].tap()
        // there should still be two cells
        XCTAssertEqual(cells.count, 2, "found instead: \(cells.debugDescription)")
        XCTAssert(app.staticTexts["Lecture Notes"].exists)
    }
    
    func testEditNote() {
        let app = XCUIApplication()
        let cells = app.tables.cells
        XCTAssertEqual(cells.count, 1, "found instead: \(cells.debugDescription)")
        cells.element(boundBy: 0).tap()
        XCTAssert(app.keyboards.count == 0, "The keyboard is shown")
        app.textFields["Title"].tap()
        XCTAssert(app.keyboards.count > 0, "The keyboard is not shown")
        app.textFields["Title"].buttons["Clear text"].tap()
        app.textFields["Title"].typeText("Updated Notes")
        app.textViews["noteText"].tap()
        app.textViews["noteText"].press(forDuration: 2)
        app.descendants(matching: .any).element(matching: .any, identifier: "Select All").tap()
        app.keys["delete"].press(forDuration: 2)
        app.buttons["Done"].tap()
        XCTAssert(app.keyboards.count == 0, "The keyboard is shown")
        app.navigationBars["Updated Notes"].buttons["Note It"].tap()
        XCTAssert(app.staticTexts["Updated Notes"].exists)
    }
    
    func testSwipeDeleteNote() {
        let app = XCUIApplication()
        let cells = app.tables.cells
        // there should be one cell added during setup
        XCTAssertEqual(cells.count, 1, "found instead: \(cells.debugDescription)")
        cells.element(boundBy: 0).swipeLeft()
        cells.element(boundBy: 0).buttons["Delete"].tap()
        // if we delete the cell there should be none remaining
        XCTAssertEqual(cells.count, 0, "found instead: \(cells.debugDescription)")
    }
    
    func testTapDeleteNote() {
        let app = XCUIApplication()
        let table = app.tables
        let cells = app.tables.cells
        XCTAssertEqual(cells.count, 1, "found instead: \(cells.debugDescription)")
        XCTAssertTrue(app.navigationBars["Note It"].buttons["Edit"].exists)
        app.navigationBars["Note It"].buttons["Edit"].tap()
        XCTAssertTrue(app.navigationBars["Note It"].buttons["Done"].exists)
        table.element(boundBy: 0).buttons["Delete Sample Note"].tap()
        cells.element(boundBy: 0).buttons["Delete"].tap()
        app.navigationBars["Note It"].buttons["Done"].tap()
        XCTAssertTrue(app.navigationBars["Note It"].buttons["Edit"].exists)
        XCTAssertEqual(cells.count, 0, "found instead: \(cells.debugDescription)")
    }
    
    func testReorderCells() {
        // add a second note
        let app = XCUIApplication()
        let cells = app.tables.cells
        app.navigationBars["Note It"].buttons["Add"].tap()
        cells.element(boundBy: 1).tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Second Note")
        app.textViews["noteText"].tap()
        app.textViews["noteText"].typeText("second note details.")
        app.navigationBars["Second Note"].buttons["Note It"].tap()
        // now rearrange
        app.navigationBars["Note It"].buttons["Edit"].tap()
        let cell1 = app.buttons["Reorder Sample Note"]
        let cell2 = app.buttons["Reorder Second Note"]
        cell1.press(forDuration: 0.5, thenDragTo: cell2)
        app.navigationBars["Note It"].buttons["Done"].tap()
        // check notes have been switched
        XCTAssertEqual(cells.element(boundBy: 0).staticTexts.element(boundBy: 0).label, "Second Note")
    }
    
}
