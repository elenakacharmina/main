import UIKit
import DataProvider

class FollowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var userId: User.Identifier!
    
    var postId: Post.Identifier!
    
    var vcId: String!
    
    var listFollow: [User]!
    
    let identifier = "MyCell"
    
    var clickedId: User.Identifier?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vcId == "Followers" {
            
            listFollow = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userId)
            self.navigationItem.title = "Followers"
        } else if vcId == "Following" {
            
            listFollow = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userId)
            self.navigationItem.title = "Following"
        } else {
            listFollow = []
            if let  arrayId =  DataProviders.shared.postsDataProvider.usersLikedPost(with: postId) {
                for i in 0..<arrayId.count {
                    if let next = DataProviders.shared.usersDataProvider.user(with: arrayId[i]) {
                        listFollow.append(next)
                    }
                }
            } else {
                listFollow = []
            }
            
            self.navigationItem.title = "Following"
        }
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.frame
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier ?? ""
        if segueIdentifier == "ToUserProfile" {
            let vc = segue.destination as? ProfileViewController
            if let id = clickedId {
                vc?.currentUser = DataProviders.shared.usersDataProvider.user(with: id) ?? DataProviders.shared.usersDataProvider.currentUser()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFollow.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        followCell.imageView?.image = listFollow?[indexPath.row].avatar
        followCell.textLabel?.text = listFollow?[indexPath.row].username
        
        return followCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickedId = listFollow[indexPath.row].id
        performSegue(withIdentifier: "ToUserProfile", sender: tableView)
    }
    
    
}
