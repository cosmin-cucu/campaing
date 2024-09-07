//
//  FakeTargetingSpecificsProvider.swift
//  campaINGTests
//
//  Created by Cosmin Cucu on 7/9/24.
//
@testable import campaING

struct FakeTargetingSpecificsProvider : TargetingSpecificsProviding {
    var targetingSpecifics: [TargetingSpecific] { [
        TargetingSpecific(name: "Sex", campaignChannels: ["Google"]),
        TargetingSpecific(name: "Age", campaignChannels: ["Instagram", "Facebook"]),
        TargetingSpecific(name: "Location", campaignChannels: ["Twitter", "Instagram", "Facebook"])
    ] }
}
