import Foundation
import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  @IBOutlet weak var textField: UITextField!
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }
  

  @IBAction func done() {
    print("Contents of the Text field: \(textField.text)")
    dismiss(animated: true, completion: nil)
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    
    doneBarButton.isEnabled = (newText.length > 0)
    
    // TODO: Clear also grays out done button. 
    
    return true
  }
}
