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
  @IBOutlet weak var editItemTextField: UITextField!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  var dueDate = Date()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let item = itemToEdit else { return }

    title = "Edit Item"
    editItemTextField.text = item.text
    editItemTextField.delegate = self // set the delegate
    doneBarButton.isEnabled = true
    shouldRemindSwitch.isOn = item.shouldRemind
    dueDate = item.dueDate
    
    updateDueDateLabel()
  }
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    editItemTextField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  

  @IBAction func done() {
    if let item = itemToEdit {
      item.text = editItemTextField.text!
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = dueDate
      
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let item = ChecklistItem()
      item.text = editItemTextField.text!
      item.checked = false
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = dueDate
      
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString

    // if someone just enters in whitespace it's not very useful
    doneBarButton.isEnabled = ((newText.trimmingCharacters(in: NSCharacterSet
                                        .whitespacesAndNewlines) as NSString)
                                                                  .length > 0)
    return true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
  }
  
  
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
}
