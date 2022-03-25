import SwiftUI

struct MicrosoftLoginView: View {
    @State private var isAuthenticated = false
    @State private var graphResult = ""
    @State private var accessTokenSource = ""

    var body: some View {
        VStack {
            Button {
                MSALAuthentication.signin(completion: { securityToken, isTokenCached, expiresOn in
                    isAuthenticated = true
                    accessTokenSource = "Access Token: \(isTokenCached! ? "Cached" : "Newly Acquired") Expires: \(expiresOn!)";
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
            } label: {
                Text("Sign In (If needed) & Call Graph")
            }
            if isAuthenticated {
                Text("Microsoft Graph Response:")
                Text(graphResult)
                Text(accessTokenSource)
                Button {
                    MSALAuthentication.signout() { () in
                        isAuthenticated = false

                        graphResult = ""
                    }
                } label: {
                    Text("Sign Out")
                }
            }
        }
        #if os(macOS)
        .frame(width: 800, height: 600)
        #endif
    }
}
