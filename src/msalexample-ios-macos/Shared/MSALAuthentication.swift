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
        var cachedAccessToken: String? = nil

        // Ideally, you'd first attempt to use a cached access token if one was available. This will renew
        // existing, but expired access tokens if possible. This pattern would be what you'd use
        // on subsequent calls that require the usage of the same same access token.
        let msalParams = MSALAccountEnumerationParameters()
        msalParams.returnOnlySignedInAccounts = true
        kMSALClient.getCurrentAccount(with: msalParams) { (currentAccount, _, error) in
            if let errorDescription = error?.localizedDescription {
                print(errorDescription)
                return
            }
            guard let account = currentAccount else { return }

            let silentParameters = MSALSilentTokenParameters(scopes: ["user.read"], account: account)
            kMSALClient.acquireTokenSilent(with: silentParameters) { (result, error) in
                guard let authResult = result, error == nil else {

                let nsError = error! as NSError

                    if (nsError.domain == MSALErrorDomain &&
                        nsError.code == MSALError.interactionRequired.rawValue) {
                        // Interactive auth will be required. No usable cached token was found for this scope + account
                        // or simply Azure AD insists in an interactive user flow.
                        return
                    }

                    // Unhandled NSError code.
                    completion(nil)
                    return
                }

                cachedAccessToken = authResult.accessToken
                return
            }
        }

        if cachedAccessToken != nil {
            completion(cachedAccessToken)
            return
        }
        else {
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
            kMSALClient.acquireToken(with: interactiveParameters, completionBlock: { (result, error) in
                guard let authResult = result, error == nil else {
                    print(error!.localizedDescription)

                    completion(nil)
                    return
                }

                completion(authResult.accessToken)
                return
            })
        }
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
