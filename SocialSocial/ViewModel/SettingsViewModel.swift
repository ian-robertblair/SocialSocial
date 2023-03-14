//
//  SectionViewModel.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/28.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var alertSound: Bool = false
    @Published var alertTone: String = "default2"
    
    init() {}
}
