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
                    MSALAuthentication.signin(completion: { securityToken in
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
                    // IMPORTANT: this require keychain capabilities to be added and signed with a valid development certificate. For more information, please refer
                    // to https://github.com/AzureAD/microsoft-authentication-library-for-objc/tree/3bc25ad3c38c0f0044e3fc624a841ac4789478c0#macos-only-steps
                    MSALAuthentication.signout() { () in
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
