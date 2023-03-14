//
//  HomeView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel()
    @EnvironmentObject var login:LoginViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let image = login.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 5)
                }
                
                Spacer()
                
                
                //VStack {
                VStack {
                    
                    HStack {
                        Text(login.userRecord?["userName"] ?? "")
                            .font(.custom("futura", size: 22))
                            .padding()
                        Button {
                            //
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .font(.custom("futura", size: 22))
                        
                        
                    }
                    
                    
                    
                    Text(login.bio ?? "")
                        .font(.custom("futura", size: 16))
                    .padding()
                }
                
                Spacer()
            }//VStack
            .padding()
            //.ignoresSafeArea()
        }
    }
}

