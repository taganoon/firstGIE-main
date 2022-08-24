import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
                get { return .fullScreen }
                set { super.modalPresentationStyle = newValue }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Timeline" {
            let user = sender as! User
            let destination = segue.destination as! TimelineViewController
            destination.me = AppUser(data: ["userID": user.uid])
        }
    }
    
    @IBAction func tappedSignInButton() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result, result.user.isEmailVerified {
                self.performSegue(withIdentifier: "Timeline", sender: result.user)
            }
        }
    }
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
}
