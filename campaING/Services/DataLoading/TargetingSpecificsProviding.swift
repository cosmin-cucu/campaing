//
//  TargetingSpecificsProviding.swift
//  campaING
//
//  Created by Cosmin Cucu on 5/9/24.
//
import Foundation

protocol TargetingSpecificsProviding {
    var targetingSpecifics: [TargetingSpecific] { get }
    func availableSpecificsFor(_ selectedSpecifics: [TargetingSpecific]) -> [TargetingSpecific]
}

extension TargetingSpecificsProviding {
    func availableSpecificsFor(_ selectedSpecifics: [TargetingSpecific]) -> [TargetingSpecific] {
        guard !selectedSpecifics.isEmpty else { return targetingSpecifics }
        
        return targetingSpecifics.filter { specific in
            selectedSpecifics
                .map { $0.campaignChannels }
                .compactMap { channels in
                    channels.compactMap { $0 }
                }
                .contains(specific.campaignChannels)
        }
    }
}

struct LocalJSONTargetingSpecificsLoader: TargetingSpecificsProviding {
    var targetingSpecifics: [TargetingSpecific] {
        let fileName = "TargetingSpecifics.json"
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("Couldn't find file \(fileName)")
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([TargetingSpecific].self, from: data)
        } catch let error {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}
