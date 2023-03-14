//
//  RegistrationView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var vm = RegistrationViewModel()
    @ObservedObject var login:LoginViewModel
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                Text("Name:")
                TextField("", text: $vm.userName)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.black)
                    }
                    .padding()
                
                Text("Bio:")
                TextEditor(text: $vm.bio)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.black)
                    }
                    .padding()
                
                HStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Button {
                        //
                    } label: {
                        Text("Add Picture")
                    }
                    .padding()

                }
            }
          
            Button {
                //
                vm.registerUser(user: login.userRecord)
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.black)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .padding()
            }
            

        }//VStack
        .padding()
       
        
    }//VStack
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(login: LoginViewModel())
    }
}
