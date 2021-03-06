//
//  MasterViewController.swift
//  Example
//
//  Created by nakajijapan on 2017/07/19.
//  Copyright © 2017 nakajijapan. All rights reserved.
//

import UIKit
import Ajimi

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController?
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        let hideAjimiButton = UIBarButtonItem(title: "hide", style: .plain, target: self, action: #selector(hideAjimi(_:)))
        let showAjimiButton = UIBarButtonItem(title: "show", style: .plain, target: self, action: #selector(showAjimi(_:)))

        navigationItem.rightBarButtonItems = [addButton, showAjimiButton, hideAjimiButton]

        if let split = splitViewController {
            let controllers = split.viewControllers

            guard let navigationController = controllers[controllers.count-1] as? UINavigationController else {
                return
            }

            detailViewController = navigationController.topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func hideAjimi(_ sender: Any) {
        Ajimi.hide()
    }

    func showAjimi(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            Ajimi.show(appDelegate.ajimiOptions)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let object = objects[indexPath.row] as? NSDate else { return }
                guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else { return }
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let object = objects[indexPath.row] as? NSDate else {
            fatalError("invalid object data")
        }
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}
