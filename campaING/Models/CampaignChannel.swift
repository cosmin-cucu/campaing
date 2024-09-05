//
//  CampaignChannel.swift
//  campaING
//
//  Created by Cosmin Cucu on 18/8/24.
//

import Foundation

struct CampaignChannel: Codable, Hashable, BuilderTableViewRepresentableType {
    let identifier: String
    let campaigns: [Campaign]?
    
    
    init(identifier: String) {
        self.identifier = identifier
        campaigns = nil
    }
}

extension CampaignChannel {
    var name: String {
        return identifier
    }
}
