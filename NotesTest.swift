
import XCTest
@testable import Note_It

class NotesTests: XCTestCase {
    
    override func setUp() {
        Notes.sharedInstance.add(note: Note(title: "Note One", text: "Details of note one"))
        Notes.sharedInstance.add(note: Note(title: "Note Two", text: "Details of note two", favourite: true))
        Notes.sharedInstance.add(note: Note(title: "Note Three", text: "Details of note three", favourite: false))
    }
    
    override func tearDown() {
        Notes.sharedInstance.clearList()
        super.tearDown()
    }
    
    func testAddNewNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        let note = Note(title: "Note Four", text: "Details of note four")
        notes.add(note: note)
        XCTAssertEqual(notes.count, 4)
    }
    
    func testAddMultipleNotes() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        notes.add(note: Note(title: "Note Four", text: "Details of note four", favourite: false))
        notes.add(note: Note(title: "Note Five", text: "Details of note five", favourite: true))
        notes.add(note: Note(title: "Note Six", text: "Details of note six"))
        XCTAssertEqual(notes.count, 6)
    }
    
    func testRetrieveFirstNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        let date = Date()
        let calendar = Calendar.current
        do {
            let note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One")
            XCTAssertEqual(note.text, "Details of note one")
            XCTAssertEqual(note.favourite, false)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveSingleNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        let date = Date()
        let calendar = Calendar.current
        do {
            let note = try notes.getNote(atIndex: 1)
            XCTAssertEqual(note.title, "Note Two")
            XCTAssertEqual(note.text, "Details of note two")
            XCTAssertEqual(note.favourite, true)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveLastNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        let date = Date()
        let calendar = Calendar.current
        do {
            let note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three")
            XCTAssertEqual(note.text, "Details of note three")
            XCTAssertEqual(note.favourite, false)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTFail()
        }
    }
    
    func testRetrieveInvalidNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
            let _ = try notes.getNote(atIndex: 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(index, 3, "the exception shound pass array index 3")
            XCTAssertTrue(true, "retrieving an invalid index should throw an outOfRange exception")
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveFirstNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
            try notes.remove(at: 0)
            XCTAssertEqual(notes.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveLastNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
            try notes.remove(at: 2)
            XCTAssertEqual(notes.count, 2)
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveInvalidNote() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
            try notes.remove(at: 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3)
        } catch {
            XCTFail()
        }
    }
    
    func testInsertAtFirstIndex() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
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
        XCTAssertEqual(notes.count, 3)
        do {
            let note = Note(title: "Note Five", text: "Details of note five")
            try notes.insert(note: note, at: 4)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 4)
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateFirstIndex() {
        let notes = Notes.sharedInstance
        let date = Date()
        let calendar = Calendar.current
        XCTAssertEqual(notes.count, 3)
        do {
            var note = Note(title: "Note One Update", text: "Updated details of note one", favourite: true)
            try notes.update(note: note, at: 0)
            XCTAssertEqual(notes.count, 3)
            note = try notes.getNote(atIndex: 0)
            XCTAssertEqual(note.title, "Note One Update")
            XCTAssertEqual(note.text, "Updated details of note one")
            XCTAssertEqual(note.favourite, true)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateMiddleIndex() {
        let notes = Notes.sharedInstance
        let date = Date()
        let calendar = Calendar.current
        XCTAssertEqual(notes.count, 3)
        do {
            var note = Note(title: "Note Two Update", text: "Updated details of note two", favourite: false)
            try notes.update(note: note, at: 1)
            XCTAssertEqual(notes.count, 3)
            note = try notes.getNote(atIndex: 1)
            XCTAssertEqual(note.title, "Note Two Update")
            XCTAssertEqual(note.text, "Updated details of note two")
            XCTAssertEqual(note.favourite, false)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateLastIndex() {
        let notes = Notes.sharedInstance
        let date = Date()
        let calendar = Calendar.current
        XCTAssertEqual(notes.count, 3)
        do {
            var note = Note(title: "Note Three Update", text: "Updated details of note three", favourite: true)
            try notes.update(note: note, at: 2)
            XCTAssertEqual(notes.count, 3)
            note = try notes.getNote(atIndex: 2)
            XCTAssertEqual(note.title, "Note Three Update")
            XCTAssertEqual(note.text, "Updated details of note three")
            XCTAssertEqual(note.favourite, true)
            XCTAssertEqual(calendar.component(.month, from: note.modified), calendar.component(.month, from: date))
            XCTAssertEqual(calendar.component(.day, from: note.modified), calendar.component(.day, from: date))
            XCTAssertEqual(calendar.component(.hour, from: note.modified), calendar.component(.hour, from: date))
        } catch {
            XCTAssertFalse(false, "no error should be thrown")
        }
    }
    
    func testUpdateInvalidIndex() {
        let notes = Notes.sharedInstance
        XCTAssertEqual(notes.count, 3)
        do {
            let note = Note(title: "Note Four Update", text: "Updated details of note four", favourite: true)
            try notes.update(note: note, at: 3)
            XCTAssertEqual(notes.count, 3)
            XCTFail()
        } catch NoteError.outOfRange(let index) {
            XCTAssertEqual(notes.count, 3)
            XCTAssertEqual(index, 3)
        } catch {
            XCTFail()
        }
    }
    
}
