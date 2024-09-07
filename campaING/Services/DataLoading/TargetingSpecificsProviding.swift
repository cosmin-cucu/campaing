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
        let selectedSpecificsChannels =
                selectedSpecifics
                .map { Set($0.campaignChannels) }
                .reduce(Set<String>(selectedSpecifics.first?.campaignChannels ?? []))  { partialResult, set -> Set<String> in
                    return partialResult.intersection(set)
                }
        
        return targetingSpecifics.filter { specific in
            !selectedSpecificsChannels.isDisjoint(with: specific.campaignChannels)
        }
    }
}

struct LocalJSONTargetingSpecificsLoader: TargetingSpecificsProviding {
    let jsonFile = "TargetingSpecifics.json"
    var targetingSpecifics: [TargetingSpecific] {
        do {
            let data = try JSONReader.read(jsonFile)
            let decoder = JSONDecoder()
            return try decoder.decode([TargetingSpecific].self, from: data)
        } catch let error {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}
