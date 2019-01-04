//
//  FirebaseRemoteConfig.swift
//  Pettitude
//
//  Created by Arthur Papailhau on 03/01/2019.
//  Copyright © 2019 Arthur Papailhau. All rights reserved.
//

import FirebaseAnalytics
import FirebaseRemoteConfig

class FirebaseRemoteConfig {
    static let shared = FirebaseRemoteConfig()

    private var remoteConfig: RemoteConfig
    private let defaultsConfig: [String: NSObject] = [
        PettitudeConstants.confidenceThresholdKey: PettitudeConstants.confidenceThreshold as NSObject
    ]

    init() {
        remoteConfig = RemoteConfig.remoteConfig()

        #if DEBUG
        let remoteConfigSetting = RemoteConfigSettings.init(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSetting
        #endif

        remoteConfig.setDefaults(defaultsConfig)
    }

    func fetch() {
        let expirationDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if let error = error {
                Analytics.logEvent("error_fetch_remoteConfig", parameters: ["description": error.localizedDescription])
            }
            if status == .success {
                self.remoteConfig.activateFetched()
                Analytics.logEvent("fetch_remoteConfig_success", parameters: nil)
            }
        }
    }

    func getValue(for key: String) -> RemoteConfigValue {
        return remoteConfig.configValue(forKey: key)
    }
}
