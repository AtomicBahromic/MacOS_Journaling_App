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
    
    public func enter(cue: String, statement: String) {
        let e = Entry(id: nil, date: Date(), Prompt: cue, Statement: statement, EntryID: 0)
        let success: ()? = try? dbQueue?.write { db in
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
            t.column("EntryID", .integer).notNull()
          }
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
    
    

    
}

struct Entry: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var date: Date
    var Prompt: String
    var Statement: String
    var EntryID: Int
}


