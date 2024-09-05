//
//  JSONReader.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import Foundation

struct JSONReader {
    static func read(_ fileName: String) throws -> Data {
        let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil)
        guard let fileURL else {
            fatalError("Couldn't find file \(fileName)")
        }
        return try Data(contentsOf: fileURL)
    }
}
