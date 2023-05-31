//
//  SubjectCommand.swift
//  
//
//  Created by Alexey Ivanov on 2/7/23.
//

import Foundation

public struct SubjectCommand: SMTPCommand {
    public let subjectText: String
    
    public var value: String {
        "Subject:" + " " + subjectText
    }
    
    public init(subjectText: String) {
        self.subjectText = subjectText
    }
}
