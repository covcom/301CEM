
import XCTest
@testable import Note_It

class NotesTests: XCTestCase {
    
    override func tearDown() {
        let notes = Notes.sharedInstance
        notes.clearList()
        super.tearDown()
    }
    
    func testAddSingleNote() {
        let notes = Notes.sharedInstance
        notes.add(note: Note(title: "Note One", text: "Details of note one"))
        XCTAssertEqual(notes.count, 1)
    }
    
    func testAddMultipleNotes() {
        let notes = Notes.sharedInstance
        notes.add(note: Note(title: "Note One", text: "Details of note one"))
        notes.add(note: Note(title: "Note Two", text: "Details of note two"))
        notes.add(note: Note(title: "Note Three", text: "Details of note three"))
        XCTAssertEqual(notes.count, 3)
    }
    
    func testRetrieveSingleNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            let note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One")
            XCTAssertEqual(note.text, "Details of note one")
        } catch {
            XCTAssertFalse(false, "no exception should be thrown")
        }
    }
    
    func testRetrieveLastNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            let note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three")
            XCTAssertEqual(note.text, "Details of note three")
        } catch {
            XCTAssertFalse(false, "no exception should be thrown")
        }
    }
    
    func testRetrieveInvalidNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            let _ = try notes.getNote(atIndex: 3)
            XCTFail("an exception should be thrown so this line never executed")
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
            XCTAssertTrue(true, "retrieving an invalid index should throw an outOfRange exception")
        } catch {
            XCTAssertFalse(false, "no other error should be thrown")
        }
    }
    
    func testRemoveOnlyNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            XCTAssertEqual(notes.count, 1)
            try notes.remove(at: 0)
            XCTAssertEqual(notes.count, 0)
        } catch {
            XCTAssertFalse(false, "no exception should be thrown")
        }
    }
    
    func testRemoveLastNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            try notes.remove(at: 2)
            XCTAssertEqual(notes.count, 2)
        } catch {
            XCTAssertFalse(false, "no exception should be thrown")
        }
    }
    
    func testRemoveInvalidNote() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            try notes.remove(at: 3)
            XCTFail("an exception should be thrown so this line never executed")
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
            XCTAssertTrue(true, "retrieving an invalid index should throw an outOfRange exception")
        } catch {
            XCTAssertFalse(false, "no other error should be thrown")
        }
    }
    
    func testInsertAtFirstIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Zero", text: "Details of note zero")
            try notes.insert(note: note, at: 0)
            XCTAssertEqual(notes.count, 4)
        } catch {
            XCTAssertFalse(false, "no error should be thrown")
        }
    }
    
    func testInsertAtLastIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Four", text: "Details of note four")
            try notes.insert(note: note, at: 3)
            XCTAssertEqual(notes.count, 4)
        } catch {
            XCTAssertFalse(false, "no error should be thrown")
        }
    }
    
    func testInsertAtInvalidIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Five", text: "Details of note five")
            try notes.insert(note: note, at: 4)
            XCTFail("an exception should be thrown so this line never executed")
        } catch NoteError.outOfRange(let index) {
            print("error with index \(index)")
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 4, "the exception shound pass array index 4")
            XCTAssertTrue(true, "retrieving an invalid index should throw an outOfRange exception")
        } catch {
            XCTAssertFalse(false, "no other error should be thrown")
        }
    }
    
    func testUpdateFirstIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            XCTAssertEqual(notes.count, 1)
            var note = Note(title: "Note One Update", text: "Updated details of note one")
            try notes.update(note: note, at: 0)
            XCTAssertEqual(notes.count, 1)
            note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One Update")
            XCTAssertEqual(note.text, "Updated details of note one")
        } catch {
            XCTAssertFalse(false, "no error should be thrown")
        }
    }
    
    func testUpdateLastIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            var note = Note(title: "Note Three Update", text: "Updated details of note three")
            try notes.update(note: note, at: 2)
            XCTAssertEqual(notes.count, 3)
            note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three Update")
            XCTAssertEqual(note.text, "Updated details of note three")
        } catch {
            XCTAssertFalse(false, "no error should be thrown")
        }
    }
    
    func testUpdateInvalidIndex() {
        let notes = Notes.sharedInstance
        do {
            notes.add(note: Note(title: "Note One", text: "Details of note one"))
            notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Four Update", text: "Updated details of note four")
            try notes.update(note: note, at: 3)
            XCTFail("an exception should be thrown so this line never executed")
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
        } catch {
            XCTAssertFalse(false, "no other error should be thrown")
        }
    }
    
}
