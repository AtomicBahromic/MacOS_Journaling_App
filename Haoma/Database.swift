//
//  Database.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-07-15.
//

import GRDB
import Cocoa

class DataController {
    static let shared = DataController()
    private(set) var dbQueue: DatabaseQueue!
    private let dbURL: URL
    
    private init() {
        // application support folder code you already have
        let folderURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        dbURL = folderURL.appendingPathComponent("db.sqlite")
        openDatabase()      // creates dbQueue and runs migrations
    }
    
    private func openDatabase() {
        dbQueue = try! DatabaseQueue(path: dbURL.path)
        try! migrator.migrate(dbQueue)
    }
    
#if DEBUG
    /// Danger: deletes the sqlite file and recreates the DB from migrations.
    func wipeDatabaseForDevelopment() throws {
        // Release the queue (deinit closes file)
        dbQueue = nil
        
        // Remove file if it exists
        if FileManager.default.fileExists(atPath: dbURL.path) {
            try FileManager.default.removeItem(at: dbURL)
        }
        
        // Re-open and re-run migrations
        openDatabase()
    }
#else
    func wipeDatabaseForDevelopment() throws {
        // no-op in release
        throw NSError(domain: "DataController", code: 1, userInfo: [NSLocalizedDescriptionKey: "wipe is disabled in non-debug builds"])
    }
#endif
    
    public func enter(cue: String, statement: String, formId: Int64? = nil) {
        let e = Entry(id: nil, date: Date(), Prompt: cue, Statement: statement, formId: formId)
        let success: ()? = try? dbQueue.write { db in
            try e.insert(db)
        }
        
        if success == nil {
            print("Failed to write to database")
        } else {
            print("great success")
        }
    }
    
    var migrator: DatabaseMigrator {
        var m = DatabaseMigrator()
        m.registerMigration("createEntry") { db in
          try db.create(table: "entry") { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("date", .datetime).notNull()
            t.column("Prompt", .text).notNull()
            t.column("Statement", .text).notNull()
          }
        }
        
        m.registerMigration("addFormTable_and_formIdToEntry") { db in
            // Create the parent/form table
            try db.create(table: "form") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("createdAt", .datetime).notNull()
                t.column("formType", .text) // optional metadata
            }
            
            // Add nullable formId column to entry (ALTER TABLE)
            try db.alter(table: "entry") { t in
                t.add(column: "formId", .integer)
            }
            
            // Optional: create an index to speed up queries by formId
            try db.create(index: "idx_entry_formId", on: "entry", columns: ["formId"])
        }
        return m
      }
    
    var todayEntries: [Entry] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        return allEntries.filter {
            $0.date >= startOfDay && $0.date < nextDay
        }
    }
    
    var allEntries: [Entry] {
        try! dbQueue?.read { db in
            try Entry.fetchAll(db)
        } ?? []
    }
    
}

extension DataController {
    /// Delete all entries whose `date` lies on the given calendar day.
    func deleteEntries(on specificDate: Date) throws {
        let startOfDay = Calendar.current.startOfDay(for: specificDate)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        _ = try dbQueue?.write { db in
            try Entry
                .filter(Column("date") >= startOfDay && Column("date") < nextDay)
                .deleteAll(db)
        } ?? 0
    }
    
    // Create a new form row and return its autoincremented id
    func createForm(formType: String? = nil) throws {
        let form = Form(id: nil, createdAt: Date(), formType: formType)
        try dbQueue.write { db in
            try form.insert(db)   // after insert, form.id is populated
        }          // safe because insert sets the id
    }
    
    // Read the latest form (most-recent id)
    func latestForm() throws -> Form? {
        try dbQueue.read { db in
            try Form.order(Column("id").desc).fetchOne(db)
        }
    }
    
}

struct Form: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var createdAt: Date
    var formType: String?   // optional metadata
}

struct Entry: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var date: Date
    var Prompt: String
    var Statement: String
    var formId: Int64?      // new: links to Form.id
}


