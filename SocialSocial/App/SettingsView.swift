//
//  SettingsView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsViewModel()
    
    var body: some View {
        VStack {
            Text("SocialSocial")
                .font(.custom("futura", size: 44))
                .foregroundColor(.white)
            Form {
                Section("General Settings") {
                    //
                    Toggle(isOn: $vm.alertSound) {
                        Text("Post Alert")
                    }
                    
                    .onChange(of: vm.alertSound) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "enableSound")
                    }
                    
                    Picker(selection: $vm.alertTone) {
                        Text("Default").tag("default2")
                        Text("Churp").tag("churp")
                        Text("Space").tag("space")
                        Text("Bells").tag("bells")
                    } label: {
                        Text("Alert Tone")
                    }
                    .onChange(of: vm.alertTone) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "alertTone")
                        print("sound set to \(newValue)")
                    }

                    
                }
                
                Section("Application") {
                    //
                    HStack {
                        Text("Product").foregroundColor(Color.gray)
                        Spacer()
                        Text("SocialSocial")
                    }
                    HStack {
                        Text("Compatibility").foregroundColor(Color.gray)
                        Spacer()
                        Text("iPhone & iPad")
                    }//:HStack
                    HStack {
                        Text("Developer").foregroundColor(Color.gray)
                        Spacer()
                        Text("Ian Robert Blair")
                    }//:HStack
                    HStack {
                        Text("Designer").foregroundColor(Color.gray)
                        Spacer()
                        Text("Ian Robert Blair")
                    }//:HStack
                    HStack {
                        Text("Website").foregroundColor(Color.gray)
                        Spacer()
                        Text("wixsite.socialsocial.com")
                    }//:HStack
                    HStack {
                        Text("Version").foregroundColor(Color.gray)
                        Spacer()
                        Text("1.0.0")
                    }//:HStack
                }
                
            }
        }
        .background(.black)
        .onAppear {
            vm.alertSound  = UserDefaults.standard.bool(forKey: "enableSound")
            if let tone = UserDefaults.standard.string(forKey: "alertTone") {
                vm.alertTone = tone
            } else {
                UserDefaults.standard.set("default2", forKey: "alertTone")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
