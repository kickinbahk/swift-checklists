import UIKit

class ChecklistViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

    let label = cell.viewWithTag(1000) as! UILabel
    
    if indexPath.row % 5 == 0 {
      label.text = "Walk the Dog"
    } else if indexPath.row % 5 == 1 {
      label.text = "Brush My Teeth"
    } else if indexPath.row % 5 == 2 {
      label.text = "Learn iOS Development"
    } else if indexPath.row % 5 == 3 {
      label.text = "Catch the Big Game"
    } else if indexPath.row % 5 == 4 {
      label.text = "Eat Ice Cream"
    }
    
    return cell
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

