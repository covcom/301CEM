
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
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            XCTAssertEqual(notes.count, 1)
        } catch {
            XCTFail()
        }
    }
    
    func testAddMultipleNotes() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveSingleNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            let note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One")
            XCTAssertEqual(note.text, "Details of note one")
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveLastNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            let note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three")
            XCTAssertEqual(note.text, "Details of note three")
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveInvalidNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            let _ = try notes.getNote(atIndex: 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveOnlyNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            XCTAssertEqual(notes.count, 1)
            try notes.remove(at: 0)
            XCTAssertEqual(notes.count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveLastNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            try notes.remove(at: 2)
            XCTAssertEqual(notes.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveInvalidNote() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            try notes.remove(at: 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtFirstIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Zero", text: "Details of note zero")
            try notes.insert(note: note, at: 0)
            XCTAssertEqual(notes.count, 4)
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtLastIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Four", text: "Details of note four")
            try notes.insert(note: note, at: 3)
            XCTAssertEqual(notes.count, 4)
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtInvalidIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Five", text: "Details of note five")
            try notes.insert(note: note, at: 4)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 4, "the exception shound pass array index 4")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateFirstIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            XCTAssertEqual(notes.count, 1)
            var note = Note(title: "Note One Update", text: "Updated details of note one")
            try notes.update(note: note, at: 0)
            XCTAssertEqual(notes.count, 1)
            note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One Update")
            XCTAssertEqual(note.text, "Updated details of note one")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateLastIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            var note = Note(title: "Note Three Update", text: "Updated details of note three")
            try notes.update(note: note, at: 2)
            XCTAssertEqual(notes.count, 3)
            note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three Update")
            XCTAssertEqual(note.text, "Updated details of note three")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateInvalidIndex() {
        let notes = Notes.sharedInstance
        do {
            try notes.add(note: Note(title: "Note One", text: "Details of note one"))
            try notes.add(note: Note(title: "Note Two", text: "Details of note two"))
            try notes.add(note: Note(title: "Note Three", text: "Details of note three"))
            XCTAssertEqual(notes.count, 3)
            let note = Note(title: "Note Four Update", text: "Updated details of note four")
            try notes.update(note: note, at: 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3)
        } catch {
            XCTFail()
        }
    }
    
}
