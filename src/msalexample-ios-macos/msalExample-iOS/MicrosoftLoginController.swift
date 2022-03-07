import SwiftUI
import MSAL

class MicrosoftLoginViewController: UIViewController {
    private var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let welcomeMessagetextLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 200))
        welcomeMessagetextLabel.numberOfLines = 2
        welcomeMessagetextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

        welcomeMessagetextLabel.text = "Welcome to the SwiftUI MSAL tutorial for iOS"
        
        self.view.addSubview(welcomeMessagetextLabel)
        
        let loginoutButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, height: 52))
        loginoutButton.backgroundColor = .systemBlue
        loginoutButton.setTitle("Login", for: .normal)
        loginoutButton.setTitleColor(.white, for: .normal)
        loginoutButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(loginoutButton)
    }
        
    @objc func buttonTapped(_ sender: UIButton) {
        if(!self.isAuthenticated) {
            MSALAuthentication.Signin(MSALWebviewParameters(authPresentationViewController: self), completion: { (account, securityToken, error) in
                if let _ = error {
                    return
                }

                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    sender.setTitle("Logout", for: .normal)
                }
            })
        }
        else {
            MSALAuthentication.Signout(MSALWebviewParameters(authPresentationViewController: self), completion: { (error) in
                if let _ = error {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    sender.setTitle("Login", for: .normal)
                }
            })
        }
    }
}

struct MicrosoftLoginControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MicrosoftLoginViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MicrosoftLoginControllerRepresentable>) -> MicrosoftLoginViewController {
        return MicrosoftLoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: MicrosoftLoginViewController, context: Context) {
        
    }
}
