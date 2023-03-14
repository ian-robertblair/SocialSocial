//
//  AddFeedView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/6.
//

import SwiftUI
import PhotosUI

struct AddFeedView: View {
    @StateObject var vm = AddFeedViewModel()
    @EnvironmentObject var login:LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("name:")
                TextField("", text: $vm.name)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.black)
                    }
                    .disabled(vm.disableButton ? true : false)                    .padding()
                
                Text("description:")
                TextEditor(text: $vm.desc)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.black)
                        
                    }
                    .disabled(vm.disableButton ? true : false)
                    .padding()
                
                
            }
            
            VStack {
                if let data = vm.selectedPhoto, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                
                PhotosPicker(selection: $vm.picture, matching: .images) {
                    Label("Select a photo", systemImage: "photo")
                    /*
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        //code
                    }
                     */
                }

            }
            
            Button {
                //
                vm.disableButton = true
                if let record = login.userRecord {
                    vm.addFeed(userId: record) { success in
                        if success {
                            vm.disableButton = false
                            self.presentationMode.wrappedValue.dismiss()
                           
                        }
                    }
                }
                
                
            } label: {
                Text("Add")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.black)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .padding()
                    .disabled(vm.disableButton ? true : false)
            }
            
            
        }//VStack
        .onChange(of: vm.picture, perform: { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    vm.selectedPhoto = data
                }
            }
        })
        .padding()
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
    }
}
