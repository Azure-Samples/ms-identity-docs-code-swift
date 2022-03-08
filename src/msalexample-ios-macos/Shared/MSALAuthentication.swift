import MSAL

class MSALAuthentication {
    // 'Application (client) ID' of app registration in Azure portal - this value is a GUID
    private static let kClientId = ""

    // 'Tenant ID' of your Azure AD instance - this value is a GUID
    private static let kTenantId = ""
    
    private static var kApplication: MSALPublicClientApplication?
    
    public static func Signin(_ webviewParameters: MSALWebviewParameters, completion: @escaping (MSALAccount?, _ accessToken: String?, Error?) -> Void) {
        let authority = try? MSALAuthority(url: URL(string: "https://login.microsoftonline.com/\(kTenantId)")!)
        let config = MSALPublicClientApplicationConfig(clientId: kClientId, redirectUri: nil, authority: authority)
        
        kApplication = try? MSALPublicClientApplication(configuration: config)
        
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webviewParameters)
        
        // If access token acquisition needs to happen multiple times in
        // iOS or macOS, only call this after checking for a cached token via
        // a call to kApplication?.acquireTokenSilent(with: MSALSilentTokenParameters).
        kApplication?.acquireToken(with: interactiveParameters, completionBlock: { (result, error) in
            guard let authResult = result, error == nil else {
                print(error!.localizedDescription)
                
                completion(nil, nil, error)
                return
            }
            
            completion(authResult.account, authResult.accessToken, nil)
        })
    }
    
    public static func Signout(_ webviewParameters: MSALWebviewParameters, completion: @escaping (Error?) -> Void) {
        let msalParams = MSALAccountEnumerationParameters()
        msalParams.returnOnlySignedInAccounts = true
        
        kApplication?.accountsFromDevice(for: msalParams, completionBlock: { (accounts, error) in
            guard let deviceAccounts = accounts, error == nil else {
                print(error!.localizedDescription)
                
                completion(error)
                return
            }
            
            for account in deviceAccounts {
                kApplication?.signout(with: account, signoutParameters: MSALSignoutParameters(webviewParameters: webviewParameters), completionBlock: { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(error)
                        return
                    }
                })
            }
            
            completion(nil)
        })
    }
}
