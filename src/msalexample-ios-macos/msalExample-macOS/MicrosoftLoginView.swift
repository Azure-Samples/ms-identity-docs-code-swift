import SwiftUI
import MSAL

struct MicrosoftLoginView: View {
    @State private var isAuthenticated = false

    var body: some View {
        VStack {
            Text("Welcome to the SwiftUI MSAL tutorial for iOS and macOS")
            Button {
                if (!isAuthenticated) {
                    MSALAuthentication.Signin(completion: { (account, securityToken, error) in
                        if let _ = error {
                            return
                        }

                        isAuthenticated.toggle()
                    })
                }
                else {
                    // IMPORTANT: this require keychain capabilities to be added and signed with a valid development certificate. For more information, please refer
                    // to https://github.com/AzureAD/microsoft-authentication-library-for-objc/tree/3bc25ad3c38c0f0044e3fc624a841ac4789478c0#macos-only-steps
                    MSALAuthentication.Signout(completion: { (error) in
                        if let _ = error {
                            return
                        }

                        isAuthenticated.toggle()
                    })
                }
            } label: {
                isAuthenticated ? Text("Sign Out") : Text("Sign In")
            }
        }
    }
}
