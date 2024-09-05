//
//  File.swift
//  campaING
//
//  Created by Cosmin Cucu on 6/9/24.
//


extension Dictionary where Key == CampaignChannel, Value == Campaign {
    func toHTML() -> String {
        var htmlString = "<html><head><title>Campaign Channels</title></head><body>"
        
        htmlString += "<h1>Campaign Channels</h1>"
        
        for (channel, campaign) in self {
            htmlString += """
            <div style='border: 1px solid black; padding: 10px; margin-bottom: 10px;'>
                <h2>Campaign Channel: \(channel.name)</h2>
                <h3>Campaign Details:</h3>
                <ul>
                    <li>Price: \(campaign.price)</li>
                    <li>Listings: \(campaign.listings ?? "N/A")</li>
                    <li>Optimizations: \(campaign.optimizations?.description ?? "N/A")</li>
                    <li>Features: \(campaign.features.joined(separator: ", "))</li>
                </ul>
            </div>
            """
        }
        
        htmlString += "</body></html>"
        
        return htmlString
    }
}
