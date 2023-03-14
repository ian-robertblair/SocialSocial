//
//  MembershipsView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct MembershipsView: View {
    @StateObject private var vm = MembershipsViewModel()
    @EnvironmentObject var login:LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(vm.feeds) { feed in
                        FeedCellView(name: feed.name ?? "", desc: feed.desc ?? "", picture: feed.pic, members: feed.members)
                    }
                }//List
                .searchable(text: $vm.searchText) {
                    ForEach(vm.feeds.filter {$0.name!.contains(vm.searchText)}) {
                        feed in
                        
                    }
                }//search
                .listStyle(.plain)
            }//VStack
            .sheet(isPresented: $vm.createFeed) {
                AddFeedView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        //
                        vm.createFeed.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        Image(systemName: "cloud")
                    }
                }
            }
            .onAppear {
                vm.record = login.userRecord
                vm.getMemberships()
                
        }//Appear
        }
    }
}

struct MembershipsView_Previews: PreviewProvider {
    static var previews: some View {
        MembershipsView()
    }
}
