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
  @IBOutlet weak var datePickerCell: UITableViewCell!
  @IBOutlet weak var datePicker: UIDatePicker!
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  var dueDate = Date()
  var datePickerVisible = false
  
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
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    editItemTextField.resignFirstResponder()
    
    if indexPath.section == 1 && indexPath.row == 1 {
      showDatePicker()
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    if indexPath.section == 1 && indexPath.row == 2 {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
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
  func showDatePicker() {
    datePickerVisible = true
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
  }
  
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }
  
  
}
