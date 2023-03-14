//
//  SendMessageView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct SendMessageView: View {
    @StateObject private var vm = SendMessageViewModel()
    @EnvironmentObject var login:LoginViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Feed:")
                Picker(selection: $vm.selectedFeed) {
                    ForEach(vm.feeds) { feed in
                        Text(feed.name ?? "").tag(feed.record)
                    }
                } label: {
                    Text("Feeds")
                }

                
                Text("Text:")
                TextEditor(text: $vm.text)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.black)
                    }
                    .padding()
                
                
            }
            HStack {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Button {
                    //
                } label: {
                    Text("Add Media")
                }
                .padding()

            }
        }//VStack
        .padding()
        .onAppear {
            //remove the force un-wrappign here
            vm.getRecord(name: (login.userRecord?["userName"]!)!) { success in
                if success {
                    vm.getMemberships()
                }
               
            }
            
            
        }
    }
}

struct SendMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageView()
    }
}
