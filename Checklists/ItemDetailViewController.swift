import Foundation
import UIKit


protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_
                              controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                              didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                              didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var textField: UITextField!
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let item = itemToEdit else { return }

    title = "Edit Item"
    textField.text = item.text
    textField.delegate = self // set the delegate
    doneBarButton.isEnabled = true
  }
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  

  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      item.checked = false
      
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    doneBarButton.isEnabled = ((newText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString).length > 0) // if someone just enters in whitespace it's not very useful
    return true
  }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
