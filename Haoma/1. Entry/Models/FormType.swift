//
//  JournalForms.swift
//  Haoma
//
//  Created by Bahram Salik on 2025-09-20.
//



enum FormType {
    case morning
    case night
    
    var entries: [String] {
        switch self {
        case .morning:
            return ["What do you feel right now?", "Why do you think you feel like that?" ,"How do you feel like reacting to that feeling?", "What is your duty on this planet?", "What does a day in your ideal life look like?", "What is your primary goal for today?", "How is that helpful?", "What is one thing you can do to build momentum towards your goals?", "What is one thing you're grateful for right now?"]
        case .night:
            return ["How do you feel or think about this day?", "What are the values with which you assess this day?",
                    "What were some neutral elements about this day?", "What did you do well today?",
                    "What could you have done better today?", "What values do you wish to live through tomorrow?",
                    "What methods do you wish to use to live according to those values?"
            ]
        }
    }
    
    var name: String {
        switch self {
        case .morning: "Morning"
        case .night: "Night"
        }
    }
}

