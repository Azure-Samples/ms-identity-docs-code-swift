import SwiftUI

struct MicrosoftLoginView: View {
    @State private var isAuthenticated = false
    @State private var graphResult = ""

    var body: some View {
        VStack {
            Text("Welcome to the SwiftUI MSAL tutorial for iOS and macOS")
            Text(graphResult)
            Button {
                if (!isAuthenticated) {
                    MSALAuthentication.signin(completion: { securityToken, error in
                        guard error == nil else {return}

                        isAuthenticated.toggle()

                        guard let meUrl = URL(string: "https://graph.microsoft.com/v1.0/me") else {
                            return
                        }

                        var request = URLRequest(url: meUrl)
                        request.httpMethod = "GET"
                        request.addValue("Bearer \(securityToken!)", forHTTPHeaderField: "Authorization")

                        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                                print(error!.localizedDescription)
                                return
                            }

                            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
                               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                                graphResult = String(decoding: jsonData, as: UTF8.self)
                            } else {
                                print("An error has ocurred")
                            }
                        }).resume()
                    })
                }
                else {
                    MSALAuthentication.signout() { error in
                        guard error == nil else {return}

                        isAuthenticated.toggle()

                        graphResult = ""
                    }
                }
            } label: {
                isAuthenticated ? Text("Sign Out") : Text("Sign In")
            }
        }
        #if os(macOS)
        .frame(width: 800, height: 600)
        #endif
    }
}
