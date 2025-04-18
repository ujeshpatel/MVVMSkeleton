//
//  ViewController.swift
//  DemoAPICall
//
//  Created by Ujesh Patel on 16/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let userViewModel = UserViewModel()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUsers()
    }
    
    private func setupTableView() {
        // Register Storyboard cell
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125

    }
    
    func fetchUsers() {
        userViewModel.fetchUsers {[weak self] success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    self?.tableView.reloadData()
                } else {
                    print("Failed to fetch users: \(errorMessage ?? "Unknown Error")")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        let user = userViewModel.user(at: indexPath.row)
        cell.configure(with: user)
        return cell
    }
}
