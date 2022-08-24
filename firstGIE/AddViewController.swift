import UIKit
import Firebase
import FirebaseStorage
import SwiftUI
import XCTest

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var contentTextView: UITextView!
    
    var me: AppUser!
    var database: Firestore!
    var imagepicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        database = Firestore.firestore()
        
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage =
                info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else{return}
        // Data in memory
        let data = selectedImage.jpegData(compressionQuality: 1)!
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: metadata) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
            
        self.dismiss(animated: true, completion: nil)
    }
    func setupTextView() {
        let toolBar = UIToolbar()
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpaceBarButton, doneButton]
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar
    }

    @objc func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    @IBAction func postContent() {
        let content = contentTextView.text!
        let saveDocument = database.collection("posts").document()
        saveDocument.setData([
            "content": content,
            "postID": saveDocument.documentID,
            "senderID": me.userID,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // 前の画面に戻るボタン
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addimage() {
        present(imagepicker, animated: true)
    }
}
