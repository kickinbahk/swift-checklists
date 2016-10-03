import Foundation
import UIKit

class AddItemViewController: UITableViewController {
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBOutlet weak var textField: UITextField!
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
  

  @IBAction func done() {
    print("Contents of the Text field: \(textField.text)")
    dismiss(animated: true, completion: nil)
  }
}
