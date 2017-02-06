//
//  SelectionTableViewController.swift
//  Style Fix
//
//  Created by Vidamo on 7/12/2016.
//  Copyright © 2016 JTSoft Company Limited. All rights reserved.
//

import UIKit

protocol SelectionDelegate {
  func didSelect(values: [String], fromIndexPath: IndexPath)
}

class SelectionTableViewController: UITableViewController {
  
  var selections: [String]!
  var selected = [String]()
  var indexPath: IndexPath!
  var delegate: SelectionDelegate!
  var allowMultipleSelection: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    delegate.didSelect(values: selected, fromIndexPath: indexPath)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {

      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return selections.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)

    cell.textLabel?.text = selections[indexPath.row]
    
    if selected.contains(selections[indexPath.row]) {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if allowMultipleSelection {
      if selected.contains(selections[indexPath.row]) {
        selected.remove(object: selections[indexPath.row])
      } else {
        selected.append(selections[indexPath.row])
      }
      tableView.reloadRows(at: [indexPath], with: .fade)
    } else {
      selected = [selections[indexPath.row]]
      tableView.reloadData()
    }
  }
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
