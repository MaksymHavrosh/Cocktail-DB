//
//  FiltersTableViewController.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

protocol FiltersTableViewControllerDelegate {
    func dismissFiltersTableViewController(controller: FiltersTableViewController)
}

class FiltersTableViewController: UITableViewController {
    
    var delegate: FiltersTableViewControllerDelegate?
    
    var selectedCells = [IndexPath]()
    private var deselectedFilters = [String]()
    var selectedFilters = [String]()
    private var filters = [String]() {
        didSet {
            selectedFilters = filters
            deselectedFilters = filters
        }
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        getFiltersFromServer()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < filters.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterTableViewCell.self), for: indexPath) as! FilterTableViewCell
            cell.filterName.text = filters[indexPath.row]
            
            if selectedCells.contains(indexPath) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                selectRow(cell: cell, indexPath: indexPath)
            }
            return cell
            
        } else { 
            return createApplyCell()
        }
    }
    
}

//MARK: - UITableViewDelegate

extension FiltersTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == filters.count {
            tableView.deselectRow(at: indexPath, animated: false)
            guard selectedFilters.count >= 1 else {
                showAlertView()
                return
            }
            delegate?.dismissFiltersTableViewController(controller: self)
            navigationController?.popViewController(animated: true)
            
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
            selectRow(cell: cell, indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.row != filters.count {
            let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
            cell.checkbox.image = UIImage(named: "filterOn")
            cell.filterName.textColor = .black
            
            let deselectFilter = filters[indexPath.row]
            if !selectedFilters.contains(deselectFilter) {
                selectedFilters.append(deselectFilter)
            }
        }
        if selectedCells.contains(indexPath), let index = selectedCells.firstIndex(of: indexPath) {
            selectedCells.remove(at: index)
        }
    }
    
}

//MARK: - Private

private extension FiltersTableViewController {
    
    func getFiltersFromServer() {
        ServerManager().getFilters { (filterNames) in
            self.filters = filterNames
            self.tableView.reloadData()
        }
    }
    
    func createApplyCell() -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ApplyCell")
        cell.textLabel?.text = "APPLY"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .black
        
        return cell
    }
    
    func showAlertView() {
        let alert = UIAlertController(title: "Attention", message: "Select at least 1 item", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func selectRow(cell : FilterTableViewCell, indexPath: IndexPath) {
        cell.checkbox.image = UIImage(named: "filterOff")
        cell.filterName.textColor = .gray
        
        if !selectedCells.contains(indexPath) {
            selectedCells.append(indexPath)
        }
        let deselectFilter = deselectedFilters[indexPath.row]
        if selectedFilters.contains(deselectFilter), let index = selectedFilters.firstIndex(of: deselectFilter) {
            selectedFilters.remove(at: index)
        }
    }
}

//MARK: - Actions

private extension FiltersTableViewController {
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
