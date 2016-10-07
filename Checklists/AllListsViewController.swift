import UIKit

class AllListsViewController: UITableViewController,
                              ListDetailViewControllerDelegate,
                              UINavigationControllerDelegate {
  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedChecklists
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return dataModel.lists.count
  }


  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = makeCell(for: tableView)
    let checklist = dataModel.lists[indexPath.row]
    let count = checklist.countUncheckedItems()
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .detailDisclosureButton
    
    if checklist.items.count == 0 {
      cell.detailTextLabel!.text = "No Items Yet..."
    } else if count == 0 {
      cell.detailTextLabel!.text = "All Done!"
    } else if count == 1 {
      cell.detailTextLabel!.text = "\(count) Item Remaning"
    } else {
      cell.detailTextLabel!.text = "\(count) Items Remaning"
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    dataModel.indexOfSelectedChecklists = indexPath.row
    let checklist = dataModel.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destination
                                              as! UINavigationController
      let controller = navigationController.topViewController
                                              as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {
    dataModel.lists.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .subtitle,
                             reuseIdentifier: cellIdentifier)
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          accessoryButtonTappedForRowWith indexPath: IndexPath)
                          {
    let navigationController = storyboard!.instantiateViewController(
                              withIdentifier: "ListDetailNavigationController")
                                                    as! UINavigationController
    let controller = navigationController.topViewController
                                                as! ListDetailViewController
    controller.delegate = self
    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    present(navigationController, animated: true, completion: nil)
  }
  
  func listDetailViewControllerDidCancel(
                            _ controller: ListDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData()
    
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
  
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklists = -1
    }
  }
  

  
   // MARK: Memory Warning
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}
