//
//  MarksVC.swift
//  MarkMe
//
//  Created by Stelian Todorichkov on 17.01.22.
//

import UIKit

class MarkListViewController: UIViewController{
    
    @IBOutlet private var table: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    
    private let viewModel = MarkListViewModel()
    private var router: MarkListRouter?
    private var filterData = [Mark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        // viewModel
        viewModel.delegate = self
        filterData = viewModel.marks
        
        //router
        router = MarkListRouter(root: self)
        
        //table
        table.register(CustomTableViewCell.nib(), forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
    
        //searchBar
        searchBar.delegate = self
    }
}

extension MarkListViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.configure(mark: filterData[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension MarkListViewController: CustomTableDelegate{
    func goToMarkInfo(markID: String) {
        router?.goToMarkInfo(markID: markID)
    }
    
    func reloadTable() {
        if viewModel.marks.isEmpty {
            table.isHidden = true
            searchBar.isHidden = true
        }
        else {
            table.isHidden = false
            searchBar.isHidden = false
            filterData = viewModel.marks
            table.reloadData()
        }
    }
}

extension MarkListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        for mark in viewModel.marks {
            if mark.title.uppercased().starts(with: searchText.uppercased()) {
                filterData.append(mark)
            }
        }
        
        if filterData.isEmpty {
            table.isHidden = true
        }
        else {
            table.isHidden = false
        }
        
        table.reloadData()
    }
}
