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

class ListDetailViewController: UITableViewController,
                                UITextFieldDelegate,
                                IconPickerViewControllerDelegate {
  @IBOutlet weak var editListTextField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var iconImageView: UIImageView!
  
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  var iconName = "Folder"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let checklist = checklistToEdit else {return}
    
    title = "Edit Checklist"
    editListTextField.text = checklist.name
    editListTextField.delegate = self
    doneBarButton.isEnabled = true
    iconName = checklist.iconName
    iconImageView.image = UIImage(named: iconName)

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    editListTextField.becomeFirstResponder()
  }
  
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = editListTextField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self,
                                        didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: editListTextField.text!,
                                iconName: iconName)
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
  
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    let _ = navigationController?.popViewController(animated: true)
  }
  
  
}
