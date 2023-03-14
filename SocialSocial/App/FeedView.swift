//
//  FeedView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var vm = FeedViewModel()
    @EnvironmentObject var login:LoginViewModel
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollViewReader { value in
                ScrollView {
                    if vm.posts.isEmpty {
                        ProgressView("Loading posts...")
                    }
                    ForEach(vm.posts) { post in
                        PostCellView(
                            vm: vm, id: post.id, date: post.date,
                            author: post.authorName,
                            text: post.text,
                            image: post.image, audio: nil, feedName: post.feedName, hasPhoto: post.hasPhoto, authorImage: post.authorImage, recordID: post.postRecord?.recordID, likes: post.likes)
                    }
                }//Scroll
                .onChange(of: vm.posts) { _ in
                    if vm.posts.last != nil {
                        value.scrollTo(vm.posts.last!.id)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                        vm.sendMessage.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    
                }
            }
            .onAppear {
                //TODO: - onAppear get the last hour
                getPosts()
                
            }
            //TODO: - add function to refresh the likes when updating

            .onReceive(timer, perform: { _ in
                //TODO: - get the last 6 minutes
                getPosts()
                
            })
            .navigationBarBackButtonHidden(true)
        }//Nav
        .sheet(isPresented: $vm.sendMessage) {
            SendMessageView()
        }
    }
    
    func getPosts() {
        vm.getMemberships(record: login.userRecord) { result in
            if result {
                vm.getAllPosts { success in
                    if success {
                        vm.getFeedNames { success in
                            if success {
                                vm.getAuthorName()
                            }
                        }
                    }
                }
            }
        }//Get memberships
    }
    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
