import SwiftUI
import MSAL

struct MicrosoftLoginView: View {
    @State private var isAuthenticated = false

    var body: some View {
        VStack {
            Text("Welcome to the SwiftUI MSAL tutorial for macOS")
            Button {
                if (!isAuthenticated) {
                    MSALAuthentication.Signin(MSALWebviewParameters(), completion: { (account, securityToken, error) in
                        if let _ = error {
                            return
                        }

                        isAuthenticated.toggle()
                    })
                }
                else {
                    // IMPORTANT: this require keychain capabilities to be added and signin with a development team. For more information, please refer
                    // to https://github.com/AzureAD/microsoft-authentication-library-for-objc/tree/3bc25ad3c38c0f0044e3fc624a841ac4789478c0#macos-only-steps
                    MSALAuthentication.Signout(MSALWebviewParameters(), completion: { (error) in
                        if let _ = error {
                            return
                        }

                        isAuthenticated.toggle()
                    })
                }
            } label: {
                isAuthenticated ? Text("Logout") : Text("Login")
            }
        }.frame(width: 800, height: 600)
    }
}

struct MicrosoftLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MicrosoftLoginView()
    }
}
