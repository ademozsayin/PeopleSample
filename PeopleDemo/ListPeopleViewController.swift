//
//  ViewController.swift
//  PeopleDemo
//
//  Created by Adem Özsayın on 13.08.2021.
//

import UIKit

class ListPeopleViewController: UIViewController {

    var people:[Person] = []
    
    
    private lazy var peopleTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: PeopleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var refreshControl = UIRefreshControl()
    
    var _next:String = "1"
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    var isLoading:Bool = false
    
    private var previousRun = Date()
    private let minInterval = 0.05


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People"
        setupView()
        fetchData(page: _next, completionBlock: {})
    }
        
    @objc func refresh(_ sender: AnyObject) {
        fetchData(page: _next, completionBlock: {})
    }
    
    func fetchData(page:String, completionBlock: () -> Void ) {
        DataSource.fetch(next: page) { response , error in
            if let _ = error {
                print(error.debugDescription)
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
                self.peopleTableView.tableFooterView?.isHidden = true
                self.isLoading = false
                self.peopleTableView.contentOffset.y -= 100
                self.alert(title: "", message: error?.errorDescription ?? "")
            }
            if let response = response {
                let newData = response.people
                if newData.count > 0 {
                    self.people.append(contentsOf: newData)
                    let uniqueRecords = self.people.reduce([], {
                        $0.contains($1) ? $0 : $0 + [$1]
                    })
                    
                    if let next = response.next {
                        self._next = next
                    }
                    
                    DispatchQueue.main.async {
                        self.people = uniqueRecords
                        self.peopleTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.isLoading = false
                        self.spinner.stopAnimating()
                    }
                }
            }
        }
    }
}

extension ListPeopleViewController {
    private func setupView() {
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(peopleTableView)
       
        peopleTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        peopleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        peopleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        peopleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        peopleTableView.addSubview(refreshControl)
        peopleTableView.rowHeight = 60
        
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: peopleTableView.bounds.width, height: CGFloat(44))

        self.peopleTableView.tableFooterView = spinner
        self.peopleTableView.tableFooterView?.isHidden = true
    }
    

}

extension ListPeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if people.count == 0 {
            peopleTableView.setEmptyMessage( "No one here :(" )
        } else {
            peopleTableView.restore()
        }
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PeopleTableViewCell.identifier, for: indexPath) as! PeopleTableViewCell
        let person = people[indexPath.row]
        cell.setData(person: person)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if !isLoading && indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if Date().timeIntervalSince(previousRun) > minInterval {
                previousRun = Date()
                spinner.startAnimating()
                isLoading  = true
                self.fetchData(page: _next) {}
            }
        }
    }
}


extension UIViewController {
    func alert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {
               (action: UIAlertAction) in self.dismiss(animated: true, completion: nil)
           }))
           self.present(alert, animated: true, completion: nil)
       }
}
