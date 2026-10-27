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
        /// Staged identity for the Xcode token request (apptokens): when true,
        /// that request claims `phoneClientInfo` (a Mac) instead of
        /// `clientInfo`, while sign-in requests keep claiming `clientInfo`.
        public var appTokensUsesMacClientInfo: Bool

        public init(
            service: String = Constants.GrandSlam.service,
            headerVersion: String = Constants.GrandSlam.headerVersion,
            authApp: String = Constants.GrandSlam.authApp,
            userAgent: String = Constants.GrandSlam.userAgent,
            clientInfo: String = Constants.GrandSlam.clientInfo,
            xcodeVersion: String = Constants.GrandSlam.xcodeVersion,
            phoneClientInfo: String = Constants.GrandSlam.phoneClientInfo,
            appTokensUsesMacClientInfo: Bool = false
        ) {
            self.service = service
            self.headerVersion = headerVersion
            self.authApp = authApp
            self.userAgent = userAgent
            self.clientInfo = clientInfo
            self.xcodeVersion = xcodeVersion
            self.phoneClientInfo = phoneClientInfo
            self.appTokensUsesMacClientInfo = appTokensUsesMacClientInfo
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

extension SideSignHeaders.GrandSlam {
    private enum CodingKeys: String, CodingKey {
        case service, headerVersion, authApp, userAgent, clientInfo, xcodeVersion, phoneClientInfo, appTokensUsesMacClientInfo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        service = try container.decode(String.self, forKey: .service)
        headerVersion = try container.decode(String.self, forKey: .headerVersion)
        authApp = try container.decode(String.self, forKey: .authApp)
        userAgent = try container.decode(String.self, forKey: .userAgent)
        clientInfo = try container.decode(String.self, forKey: .clientInfo)
        xcodeVersion = try container.decode(String.self, forKey: .xcodeVersion)
        phoneClientInfo = try container.decode(String.self, forKey: .phoneClientInfo)
        appTokensUsesMacClientInfo = try container.decodeIfPresent(Bool.self, forKey: .appTokensUsesMacClientInfo) ?? false
    }
}
