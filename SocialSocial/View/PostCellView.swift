//
//  FeedCellView.swift
//  SocialSocial
//
//  Created by ian robert blair on 2023/2/5.
//

import SwiftUI
import CloudKit

struct PostCellView: View {
    @ObservedObject var vm:FeedViewModel
    @EnvironmentObject var login:LoginViewModel
    @State var liked:Bool = false
    let id: UUID?
    let date: Date?
    let author: String?
    let text: String?
    let image: Image
    let audio: String?
    let feedName: String?
    let hasPhoto: Bool
    let authorImage:Image?
    let recordID: CKRecord.ID?
    @State var likes: Int?
    
    
    var body: some View {
        VStack{
            HStack{
                if let feedName = feedName {
                    Text("\(feedName)")
                }
                Spacer()
                if let date = date {
                    dateFormatted(date: date)
                }
            }
            
            if hasPhoto {
                image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 250)
            }
        
            Text(text ?? "")
                .padding(.horizontal, 10)
            
            
            HStack{
                
                Button {
                    liked.toggle()
                    if liked {
                        //add func to unlike
                        if let recordID = recordID {
                            vm.likePost(recordID: recordID)
                        }
                        if likes != nil {
                            likes! += 1
                        }
                        
                        if let id = id, let record = login.userRecord {
                            vm.addToLiked(record: record, post: id.uuidString)
                        }
                       
                        
                    } else {
                        if let recordID = recordID {
                            vm.unlikePost(recordID: recordID)
                        }
                        if likes != nil {
                            likes! -= 1
                        }
                        
                        if let id = id, let record = login.userRecord {
                            vm.removeFromLiked(record: record, post: id.uuidString)
                        }
                        
                    }
                    
                    
                } label: {
                    Image(systemName: liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                }
                .tint(.black)
                
                if let likes = likes {
                    Text(String(likes))
                }
                
                
                NavigationLink {
                    //
                    CommentsView()
                } label: {
                    Image(systemName: "ellipsis.bubble")
                }
                .padding(.leading, 10)

                Text("5")
                

                Spacer()
                if let image = authorImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        
                }
                
                Text("-\(author ?? "")")
            }
           
            Divider()
                .padding()
        }
        .font(.custom("futura", size: 14))
        .padding()
        .id(id)
        .onAppear {
            if let userLiked = login.userRecord?["liked"] as? [String] {
                liked = vm.checkliked(id: id?.uuidString ?? "", liked: userLiked)
            }
            
        }
        
    }
    
    func dateFormatted(date: Date) -> some View {
        let anHourAgo = Date.now.addingTimeInterval(-3600)
        if date > anHourAgo {
            return Text("\(date, style: .relative) ago")
        } else {
            return Text("\(date.formatted())")
        }
    }
}

struct PostCellView_Previews: PreviewProvider {
    static var previews: some View {
        PostCellView(vm: FeedViewModel(), liked: false, id: UUID(), date: Date.now.addingTimeInterval(1200), author: "Ian Robert Blair", text: "A viral tweet alleges bias as ChatGPT refuses to write a poem on the positive attributes of Trump but writes one about Biden; sources: OpenAI doesn't know why.", image: Image("Judo"), audio: nil, feedName: "Beijing Chat Group", hasPhoto: true, authorImage: nil, recordID: nil, likes: 2)
    }
}
