//
//  ContentView.swift
//  GeminiChatBot
//
//  Created by Preet Pambhar on 2024-06-28.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State var userPrompt = ""
    @State var response: LocalizedStringKey = "How can i help you today?"
    @State var loding = false
    var body: some View {
        VStack {
          Text("Welcome To Genimi AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
                .padding(.top, 40)
            
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                }
                if loding{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(2)
                    
                }
            }
            TextField("Ask anything...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }
        }
        
        .padding()
    }
    func generateResponse(){
        loding = true
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                loding = false
                response = LocalizedStringKey(result.text ?? "No Response Found")
                userPrompt = ""
            }catch {
                response = "Something Went Wrong\n\(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}
