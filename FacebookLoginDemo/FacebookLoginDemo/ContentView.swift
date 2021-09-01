//
//  ContentView.swift
//  FacebookLoginDemo
//
//  Created by Thongchai Subsaidee on 1/9/2564 BE.
//

import SwiftUI
import FacebookLogin

struct ContentView: View {
    
    @State var userId: String = ""
    @State var name: String = ""
    @State var email: String = ""
    @State var token: String = ""

    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {
                        Spacer()
                        Image("f_logo_RGB-Blue_512")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Button("Faebook Login Demo") {
                            login()
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("USER ID:")) {
                    Text(userId)
                }
                
                Section(header: Text("USER DISPLAY NAME:")) {
                    Text(name)
                }
                
                Section(header: Text("EMAIL:")) {
                    Text(email)
                }
                
                Section(header: Text("Token:")) {
                    Text(token)
                }
            }
            .navigationBarTitle(Text("Facebook"))
        }
    }
    
    func login() {
        
        LoginManager().logIn(permissions: [.publicProfile, .email]) { result in
            
            switch result {
            case .success(granted: _ , declined: _, token: _):
                print("success")
                self.token = AccessToken.current?.tokenString ?? ""
                
                
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], tokenString: self.token, version: Settings.defaultGraphAPIVersion, httpMethod: .get)) { connection, values, error in
                    if let res = values {
                        if let response = res as? [String: Any] {
                            
                            if let userId = response["id"] as? String {
                                self.userId = userId
                            }
                            
                            if let name = response["name"] as? String {
                                self.name = name
                            }
                            
                            if let email = response["email"] as? String {
                                self.email = email
                            }
                            
                        
                        }
                    }
                }
                connection.start()
                
                
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("Cancelled")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
