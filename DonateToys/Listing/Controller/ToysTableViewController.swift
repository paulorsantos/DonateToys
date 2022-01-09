import UIKit
import FirebaseFirestore

class ToysTableViewController: UITableViewController {
    
    var toys: [Toy] = []
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToys()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyFormViewController = segue.destination as? ToyFormViewController,
        let row = tableView.indexPathForSelectedRow?.row {
            toyFormViewController.toy = toys[row]
        }
    }
    
    func loadToys() {
        let config: Config = Config()

        listener = config.firestore.collection(config.collection).order(by: "name", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: {snapshot, error in
            
                if let error = error {
                    print(error)
                } else {
                    guard let snapshot = snapshot else {return}
                    print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                
                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                        self.showItemsFrom(snapshot)
                    }
                }
            })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot) {
        toys.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name = data["name"] as? String, let state = data["state"] as? Int, let donorName = data["donorName"] as? String, let address = data["address"] as? String, let phoneNumber = data["phoneNumber"] as? String {
                let toy = Toy(name: name, state: state, donorName: donorName, address: address, phoneNumber: phoneNumber, id: document.documentID)
                    toys.append(toy)
            }
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let toy = toys[indexPath.row]
        cell.textLabel?.text = toy.name
        cell.detailTextLabel?.text = toy.stateName
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let toy = toys[indexPath.row]
                let config: Config = Config()
                config.firestore.collection(config.collection).document(toy.id).delete()
            }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
