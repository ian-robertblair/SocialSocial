//
//  CommentsView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/23.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
      
        VStack {
            Text("Comments View")
            
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Feed")
                            }
                            
                        }
                        
                    }
                }
                .navigationBarBackButtonHidden(true)
            
        }
       
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
