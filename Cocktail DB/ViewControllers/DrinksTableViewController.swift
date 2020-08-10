//
//  DrinksTableViewController.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import Network
import AlamofireImage

class DrinksTableViewController: UITableViewController {
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private var params = [[String : String]]()
    private var paramsName = [String]()
    private var drinksSections = [[Drink]]()
    private var sectionOnScreen = [Int]()
    private var selectedCells = [IndexPath]()
    
    private let heigthForRow: CGFloat = 134
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addPathUpdateHandler()
        getFiltersFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDrinksFromServer(for: 0, with: params.isEmpty ? [["c" : "Ordinary Drink"]] : params)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        paramsName.count == 0 ? 1 : paramsName.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        paramsName.count == 0 ? "Ordinary Drink" : paramsName[section]
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        heigthForRow
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heigthForRow
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if drinksSections.count < section + 1 || drinksSections.isEmpty {
            return 0
        } else if !drinksSections[section].isEmpty {
            return drinksSections[section].count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DrinkTableViewCell.self), for: indexPath) as! DrinkTableViewCell
        guard !drinksSections.isEmpty else { return cell }
        let drink = drinksSections[indexPath.section][indexPath.row]
        cell.drinkName.text = drink.drinkName
        
        if let url = drink.urlImage {
            cell.drinkImage.image = UIImage(named: "defaultIcon")
            cell.drinkImage?.af.setImage(withURL: url)
        }
        return cell
    }
    
}

//MARK: - Segue

extension DrinksTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FiltersTableViewController {
            vc.delegate = self
            vc.selectedCells = selectedCells
        }
    }
}

//MARK: - UITableViewDelegate

extension DrinksTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard !drinksSections.isEmpty else { return }
        let lastItemOnScreen = drinksSections[indexPath.section].count - 1
        guard indexPath.row == lastItemOnScreen, !params.isEmpty, !sectionOnScreen.contains(indexPath.section + 1), indexPath.section < params.count else { return }
        getDrinksFromServer(for: indexPath.section + 1, with: params)
    }
}

//MARK: - FiltersTableViewControllerDelegate

extension DrinksTableViewController: FiltersTableViewControllerDelegate {
    
    func dismissFiltersTableViewController(controller: FiltersTableViewController) {
        
        paramsName = controller.selectedFilters
        selectedCells = controller.selectedCells
        drinksSections.removeAll()
        sectionOnScreen.removeAll()
        params.removeAll()
        for name in paramsName {
            params.append(["c" : name])
        }
        tableView.reloadData()
    }
}

//MARK: - Private

private extension DrinksTableViewController {
    
    func getDrinksFromServer(for section: Int, with params: [[String : Any]]) {
        
        guard params.count > section else { return }
        ServerManager().getDrinks(params: params[section], success: { (drinks) in
            self.drinksSections.append(drinks)
            self.sectionOnScreen.append(section)
            self.tableView.reloadData()
        })
    }
    
    func getFiltersFromServer() {
        
        ServerManager().getFilters { (filterNames) in
            self.paramsName = filterNames
            for name in self.paramsName {
                self.params.append(["c" : name])
            }
            self.tableView.reloadData()
        }
    }
    
    func addPathUpdateHandler() {
        
        networkMonitor.pathUpdateHandler = { path in
            guard !(path.status == .satisfied) else { return }
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "No Internet", message: "Check your internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:])
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        networkMonitor.start(queue: queue)
    }
    
}
