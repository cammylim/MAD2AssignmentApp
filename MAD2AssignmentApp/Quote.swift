//
//  Quote.swift
//  MAD2AssignmentApp
//
//  Created by Yuxuan on 25/1/22.
//

import Foundation

struct QuoteElement: Codable {
    let text: String
    let author: String?
}

typealias Quote = [QuoteElement]
