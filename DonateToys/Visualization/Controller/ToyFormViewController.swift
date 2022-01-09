import UIKit
import Firebase

class ToyFormViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDonorName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var segmentedControlStateName: UISegmentedControl!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var buttonAddEdit: UIButton!
    
    var config: Config = Config()
    var toy: Toy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toy = toy {
            title = "Edição"
            textFieldName.text = toy.name
            textFieldDonorName.text = toy.donorName
            textFieldAddress.text = toy.address
            textFieldPhoneNumber.text = toy.phoneNumber
            segmentedControlStateName.selectedSegmentIndex = toy.state
            buttonAddEdit.setTitle("Alterar Brinquedo", for: .normal)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let name = textFieldName?.text, let donorName = textFieldDonorName?.text, let address = textFieldAddress?.text, let phoneNumber = textFieldPhoneNumber?.text, let state = segmentedControlStateName?.selectedSegmentIndex else {return}
        
        let data: [String: Any] = [
            "name": name,
            "donorName": donorName,
            "address": address,
            "phoneNumber": phoneNumber,
            "state": state
        ]
        
        let config: Config = Config()

         if toy != nil {
             config.firestore.collection(config.collection).document(toy!.id).updateData(data)
         } else {
             config.firestore.collection(config.collection).addDocument(data: data)
        }
        
        goBack()
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
