import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(
                                _ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
  @IBOutlet weak var editListTextField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let checklist = checklistToEdit else {return}
    
    title = "Edit Checklist"
    editListTextField.text = checklist.name
    editListTextField.delegate = self
    doneBarButton.isEnabled = true

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    editListTextField.becomeFirstResponder()
  }
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath?
                          {
    return nil
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = editListTextField.text!
      delegate?.listDetailViewController(self,
                                        didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: editListTextField.text!)
      delegate?.listDetailViewController(self,
                                         didFinishAdding: checklist)
    }
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string)
                                                          as NSString
    doneBarButton.isEnabled = ((newText.trimmingCharacters(
                                        in: NSCharacterSet
                                            .whitespacesAndNewlines)
                                            as NSString).length > 0)
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
  
  
}
