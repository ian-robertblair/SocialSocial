//
//  LoginView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    
    
    var body: some View {
       
        NavigationView {
            VStack {
                Spacer()
                VStack() {
                    Text(vm.message)
                        .padding()
                        .foregroundColor(vm.message == "Connected" ? .green : .black)
                        .font(.custom("futura", size: 22))
                    if vm.retry {
                        Button {
                            //Restry connection to icloud
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .font(.custom("futura", size: 18))
                    }
                    

                    Text(vm.message2)
                        .padding()
                        .font(.custom("futura", size: 18))
                    
                }
              Spacer()
                NavigationLink {
                    if vm.status == .unregistered {
                        RegistrationView(login: vm)
                    } else {
                        ContentView()
                    }
                    
                } label: {
                    Text(buttonText())
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(vm.status == .checking ? .gray : .black)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .font(.custom("futura", size: 20))
                        .padding()
                        .disabled(vm.status == .checking ? true : false)
                }
                

            }//VStack
            .padding()
        }//Nav
        .environmentObject(vm)
        .onAppear {
            vm.checkICloud()
            vm.getAccount()
            
        }
       
        
    }
    
    func buttonText() -> String {
        switch vm.status {
        case .checking:
           return ("PLEASE WAIT")
        case .unregistered:
            return ("REGISTER")
        default:
            return ("CONTINUE")
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
