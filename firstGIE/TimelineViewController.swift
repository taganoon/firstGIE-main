import UIKit
import Firebase

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var me: AppUser!
    var database: Firestore!
    var postArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(pressScreen))
        press.minimumPressDuration = 1.5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(press)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.collection("posts").getDocuments { (snapshots, error) in
            if error == nil, let snapshots = snapshots {
                self.postArray = []
                for document in snapshots.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                self.tableView.reloadData()
            }
        }
        
        database.collection("users").document(me.userID).setData([
            "userID": me.userID
            ], merge: true)
        
        database.collection("users").document(me.userID).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                self.me = AppUser(data: data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add" {
            let destination = segue.destination as! AddViewController
            destination.me = (sender as! AppUser)
        } else if segue.identifier == "Settings" {
            let destination = segue.destination as! SettingsViewController
            destination.me = me
        }
    }
    
    @objc
    func pressScreen() {
        performSegue(withIdentifier: "Settings", sender: me)
    }
    
    @IBAction func toAddViewController() {
        performSegue(withIdentifier: "Add", sender: me)
    }
    @IBAction func AddViewController() {
        performSegue(withIdentifier: "Settings", sender: me)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = postArray[indexPath.row].content
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        database.collection("users").document(postArray[indexPath.row].senderID).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                let appUser = AppUser(data: data)
                cell.detailTextLabel?.text = appUser.userName
            }
        }
        return cell
    }
}
