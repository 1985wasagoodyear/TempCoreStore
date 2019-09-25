//
//  HoomanListViewController.swift
//  TempCoreStore
//
//  Created by K Y on 9/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

private let CELL_ID = "HoomanCellIdentifier"

class HoomanListViewController: UIViewController {

    // MARK: - Storyboard Outlets
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        }
    }
    
    // MARK: - Properties
    
    lazy var controller: HoomanController = {
        return HoomanModelController()
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeHooman", let dest = segue.destination as? HoomanDetailViewController {
            dest.controller = controller
        }
    }

}

// MARK: - UITableView Data Source

extension HoomanListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return controller.tempHoomans.count
        case 1:
            return controller.savedHoomans.count
        default:
            fatalErrorWrongIndexPath()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID,
                                                 for: indexPath)
        let name: String?
        
        switch section {
        case 0:
            name = controller.tempHoomans[row].name
        case 1:
            name = controller.savedHoomans[row].name
        default:
            fatalErrorWrongIndexPath()
        }
                
        cell.textLabel?.text = name
        return cell
    }
    
}

// MARK: - UITableView Delegate

extension HoomanListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            controller.saveHooman(controller.tempHoomans[indexPath.row])
        case 1:
            controller.deleteHooman(controller.savedHoomans[indexPath.row])
        default:
            fatalErrorWrongIndexPath()
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header: String
        switch section {
        case 0:
            header = "Temporary Hoomans"
        case 1:
            header = "Saved Hoomans"
        default:
            fatalErrorWrongIndexPath()
        }
        return header
    }
    
}
