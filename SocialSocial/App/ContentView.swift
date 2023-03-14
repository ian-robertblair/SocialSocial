//
//  ContentView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Image(systemName: "list.dash.header.rectangle")
                }
            MembershipsView()
                .tabItem {
                    Image(systemName: "person.2.crop.square.stack")
                }
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
