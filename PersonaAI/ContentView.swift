//
//  ContentView.swift
//  PersonaAI
//
//  Created by Heical Chandra on 28/05/24.
//

import SwiftUI

struct ContentView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer:Timer?
    @State var chatService = ChatService()
    
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
            ScrollViewReader(content: { proxy in
                ScrollView{
                    ForEach(chatService.messages){ chatMessage in
                        //chatview
                        chatMessageView(chatMessage)
                    }
                }
                .onChange(of: chatService.messages){ _, _ in
                    guard let recentMessage = chatService.messages.last else{return}
                    DispatchQueue.main.async {
                        withAnimation{
                            proxy.scrollTo(recentMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatService.loadingResponse){_, newValue in
                    if newValue {
                        startLoadingAnimation()
                    }else {
                        stopLoadingAnimation()
                    }
                }
            })
            //input fields
            HStack{
                TextField("Enter a message...", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.black)
                Button(action: sendMessage){
                    Image(systemName: "paperplane.fill")
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background{
            ZStack{
                Color.black
            }
            .ignoresSafeArea()
        }
    }
    //chat message view
    @ViewBuilder func chatMessageView(_ message: ChatMessage) -> some View {
        ChatBubble(direction: message.role == .model ? .left : .right){
            Text(message.message)
                .font(.title3)
                .padding(.all, 20)
                .foregroundStyle(.white)
                .background(message.role == .model ? Color.blue : Color.green)
        }
    }
    //fetch response
    func sendMessage(){
        chatService.sendMessage(textInput)
        textInput = ""
    }
    
    //response loading animation
    func startLoadingAnimation(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {timer in
            logoAnimating.toggle()
        })
    }
    func stopLoadingAnimation(){
        logoAnimating = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ContentView()
}
