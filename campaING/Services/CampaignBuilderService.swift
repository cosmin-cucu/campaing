//
//  CampaignBuilderService.swift
//  campaING
//
//  Created by Cosmin Cucu on 27/8/24.
//

import Foundation

class CampaignBuilderService {
    private let targetingSpecifics: [TargetingSpecific] = readTargetingSpecificsJSONFromFile()
    
    var filters: [TargetingSpecific] {
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

    var selectedSpecifics = [TargetingSpecific]()
    
    func didSelectFilterAt(_ row: Int) {
        let selectedSpecific = filters[row]
        if selectedSpecifics.contains(where: { $0 == selectedSpecific }) {
            selectedSpecifics = selectedSpecifics.filter { $0 != selectedSpecific }
        } else {
            selectedSpecifics.append(filters[row])
        }
        
    }
}

fileprivate func readTargetingSpecificsJSONFromFile() -> [TargetingSpecific] {
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
