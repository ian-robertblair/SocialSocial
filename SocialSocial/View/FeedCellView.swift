//
//  FeedCellView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI

struct FeedCellView: View {
    let name:String
    let desc:String
    let picture: UIImage?
    let members:Int?
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if let picture = picture {
                        Image(uiImage: picture)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .padding(.horizontal, 5)
                    }
                    Text("Members: \(members ?? 0)")
                        .font(.caption)
                }
                
                VStack(alignment: .leading) {
                    Text(name)
                        .fontWeight(.bold)
                    Text(desc)
                        .lineLimit(6)
                    Spacer()
                }
                .font(.custom("futura", size: 14))
                .frame(height: 120)
                .padding()
            }
        }//VSTack
        .padding()
    }
}

struct FeedCellView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCellView(name: "North Beijing Judo Club", desc: "Great Judo.  We meet three times a week at the sports arena.  We have about 50 adult and 80 children.", picture:  UIImage(named: "Judo")!, members: 2)
    }
}
