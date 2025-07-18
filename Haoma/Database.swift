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
    let dbQueue: DatabaseQueue
    
    private init() {
        let folderURL = try! FileManager.default
              .url(for: .applicationSupportDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: true)
        let dbURL = folderURL.appendingPathComponent("db.sqlite")
        dbQueue = try! DatabaseQueue(path: dbURL.path)
        try! migrator.migrate(dbQueue)
    }
    
    public func enter(cue: String, statement: String) {
        let e = Entry(id: nil, date: Date(), Prompt: cue, Statement: statement)
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
        return try! dbQueue.read { db in
            try Entry.fetchAll(db)
        }
    }
    
}

struct Entry: Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var date: Date
    var Prompt: String
    var Statement: String
}


