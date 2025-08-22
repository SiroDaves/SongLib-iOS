//
//  AppConstants.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct AppConstants {
    static let appTitle = "SongLib"
    static let appCredits1 = "Siro"
    static let appCredits2 = "Titus"
    static let entitlements = "songlib_offering_1"
}

struct AppSecrets {
    static let rc_api_key: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["REVENUECAT_API_KEY"] as? String else {
            fatalError("Missing REVENUECAT_API_KEY in Secrets.plist")
        }
        return value
    }()
}
