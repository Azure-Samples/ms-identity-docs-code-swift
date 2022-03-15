import MSAL

class MSALAuthentication {
    // 'Application (client) ID' of app registration in Azure portal - this value is a GUID
    private static let kClientId = ""

    // 'Tenant ID' of your Azure AD instance - this value is a GUID
    private static let kTenantId = ""
    
    private static let kAuthority = try! MSALB2CAuthority(url: URL(string: "https://login.microsoftonline.com/\(kTenantId)")!)
    private static let kConfig = MSALPublicClientApplicationConfig(clientId: kClientId, redirectUri: nil, authority: kAuthority)

    // To use token caching, your MSAL client singleton must have a lifecycle that
    // at least matches the lifecycle of the user's session in the app.
    private static let kMSALClient: MSALPublicClientApplication = try! MSALPublicClientApplication(configuration: kConfig)
    
    public static func signin(completion: @escaping (_ accessToken: String?) -> Void) {
        #if os(iOS)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        // IMPORTANT: For this sample, it's possible to use the root window. Consider discovering the top one
        // or passing a specific ViewController if required.
        let webviewParameters = MSALWebviewParameters(authPresentationViewController: window!.rootViewController!)
        #else
        let webviewParameters = MSALWebviewParameters()
        #endif

        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webviewParameters)

        // If access token acquisition needs to happen multiple times in
        // the app, only call this after checking for a cached token via
        // a call to kApplication.acquireTokenSilent(with: MSALSilentTokenParameters).
        kMSALClient.acquireToken(with: interactiveParameters, completionBlock: { (result, error) in
            guard let authResult = result, error == nil else {
                print(error!.localizedDescription)
                
                completion(nil)
                return
            }
            
            completion(authResult.accessToken)
        })
    }
    
    public static func signout(completion: @escaping () -> Void) {
        let msalParams = MSALAccountEnumerationParameters()
        msalParams.returnOnlySignedInAccounts = true
        kMSALClient.getCurrentAccount(with: msalParams) { currentAccount, _, error in
            guard let account = currentAccount, error == nil else {
                print(error!.localizedDescription)
                return
            }

            #if os(iOS)
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            // IMPORTANT: For this sample, it's possible to use the root window. Consider discovering the top one
            // or passing a specific ViewController if required.
            let webviewParameters = MSALWebviewParameters(authPresentationViewController: window!.rootViewController!)
            #else
            let webviewParameters = MSALWebviewParameters()
            #endif

            kMSALClient.signout(with: account, signoutParameters: MSALSignoutParameters(webviewParameters: webviewParameters), completionBlock: { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            })

            completion()
        }
    }
}
