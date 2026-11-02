//
//  SideSignHeaders.swift
//  SideSign
//
//  Created by Magesh K on 11/9/26.
//  Copyright © 2026 SideSign. All rights reserved.
//

import Foundation

public struct SideSignHeaders: Codable, Sendable, Equatable {
    public var grandSlam: GrandSlam
    public var appleAuth: AppleAuth
    public var developerServices: DeveloperServices

    public init(
        grandSlam: GrandSlam = GrandSlam(),
        appleAuth: AppleAuth = AppleAuth(),
        developerServices: DeveloperServices = DeveloperServices()
    ) {
        self.grandSlam = grandSlam
        self.appleAuth = appleAuth
        self.developerServices = developerServices
    }

    public struct GrandSlam: Codable, Sendable, Equatable {
        public var service: String
        public var headerVersion: String
        public var authApp: String
        public var userAgent: String
        public var clientInfo: String
        public var xcodeVersion: String
        public var phoneClientInfo: String
        /// When true, the portal first fetches the GrandSlam URL bag
        /// (GsService2/lookup) using these same identity headers and sends
        /// the authentication requests to the bag's gsService URL, the way
        /// isideload does. GSA rejects a first SRP request whose claim was
        /// never seen fetching the bag. Default false keeps the historical
        /// behavior: POST directly to the fixed endpoint, no lookup.
        public var prefetchURLBag: Bool
        /// When true, the SRP client dictionary sends its boolean fields
        /// (bootstrap/icscrec/pbe/prkgen) as the strings "true"/"false"
        /// and fixes loc to "en_US", matching isideload's plist shape.
        /// Default false keeps the historical boolean values.
        public var cpdStringValues: Bool

        public init(
            service: String = Constants.GrandSlam.service,
            headerVersion: String = Constants.GrandSlam.headerVersion,
            authApp: String = Constants.GrandSlam.authApp,
            userAgent: String = Constants.GrandSlam.userAgent,
            clientInfo: String = Constants.GrandSlam.clientInfo,
            xcodeVersion: String = Constants.GrandSlam.xcodeVersion,
            phoneClientInfo: String = Constants.GrandSlam.phoneClientInfo,
            prefetchURLBag: Bool = false,
            cpdStringValues: Bool = false
        ) {
            self.service = service
            self.headerVersion = headerVersion
            self.authApp = authApp
            self.userAgent = userAgent
            self.clientInfo = clientInfo
            self.xcodeVersion = xcodeVersion
            self.phoneClientInfo = phoneClientInfo
            self.prefetchURLBag = prefetchURLBag
            self.cpdStringValues = cpdStringValues
        }
    }

    public struct AppleAuth: Codable, Sendable, Equatable {
        public var appIDKey: String
        public var userAgent: String

        public init(
            appIDKey: String = Constants.AppleAuth.appIDKey,
            userAgent: String = Constants.AppleAuth.userAgent
        ) {
            self.appIDKey = appIDKey
            self.userAgent = userAgent
        }
    }

    public struct DeveloperServices: Codable, Sendable, Equatable {
        public var clientID: String
        public var protocolVersion: String
        public var servicesProtocolVersion: String
        public var userAgent: String

        public init(
            clientID: String = Constants.DeveloperServices.clientID,
            protocolVersion: String = Constants.DeveloperServices.protocolVersion,
            servicesProtocolVersion: String = Constants.DeveloperServices.servicesProtocolVersion,
            userAgent: String = Constants.DeveloperServices.userAgent
        ) {
            self.clientID = clientID
            self.protocolVersion = protocolVersion
            self.servicesProtocolVersion = servicesProtocolVersion
            self.userAgent = userAgent
        }
    }
}
