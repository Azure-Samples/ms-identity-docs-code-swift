import MSAL

class MSALAuthentication {
    private static let kClientId = ""
    private static let kTenantId = ""
    
    private static var kApplication: MSALPublicClientApplication?
    
    public static func Signin(_ webviewParameters: MSALWebviewParameters, completion: @escaping (MSALAccount?, _ accessToken: String?, Error?) -> Void) {
        let authority = try? MSALAuthority(url: URL(string: "https://login.microsoftonline.com/\(kTenantId)")!)
        let config = MSALPublicClientApplicationConfig(clientId: kClientId, redirectUri: nil, authority: authority)
        
        kApplication = try? MSALPublicClientApplication(configuration: config)
        
        let interactiveParameters = MSALInteractiveTokenParameters(scopes: ["user.read"], webviewParameters: webviewParameters)
        
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
