//
//  JournalForms.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-20.
//

enum JournalForms {
    case morning
    case night
    
    var entries: [String] {
        switch self {
        case .morning:
            return ["What matters to you in this world?", "What is your duty on this planet?", "What would your ideal life look like?", "What is my primary goal for today?", "How is that helpful?", "What is one thing you can do to build momentum towards your goals?", "What is one thing you're grateful for right now?"]
        case .night:
            return ["Reflection", "Wins", "Improvements"]
        }
    }
}

