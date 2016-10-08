import UIKit

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
  weak var delegate: IconPickerViewControllerDelegate?
  let icons = [
    "No Icon",
    "#imageLiteral(resourceName: "Appointments")",
    "#imageLiteral(resourceName: "Birthdays")",
    "Chores",
    "Drinks",
    "Folder",
    "Groceries",
    "Inbox",
    "Photos",
    "Trips" ]
  
  override func tableView(_ tableView: UITableView,
                          nubmerOfRowsInSection section: Int) -> Int {
    return icons.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell",
                                             for: indexPath)
    let iconName = icons [indexPath.row]
    cell.textLabel!.text = iconName
    cell.imageVew!.image = UIImage(named: iconName)
    
    return cell
  }
}