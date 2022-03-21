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
        checkHaveMarks()
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
    
    func checkHaveMarks() {
        if filterData.isEmpty {
            table.isHidden = true
        }
        else {
            table.isHidden = false
        }
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
    func deleteMark(mark: Mark?) {
        viewModel.deleteMark(mark: mark)
    }
    
    func goToMarkInfo(markID: String) {
        router?.goToMarkInfo(markID: markID)
    }
    
    func reloadTable() {
        filterData = viewModel.marks
        checkHaveMarks()
        table.reloadData()
    }
}

extension MarkListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        if searchText == "" {
            filterData = viewModel.marks
        }
        else {
            for mark in viewModel.marks {
                if mark.title.uppercased().starts(with: searchText.uppercased()) {
                    filterData.append(mark)
                }
            }
        }
        checkHaveMarks()
        table.reloadData()
    }
}
