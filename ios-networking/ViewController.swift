//
//  ViewController.swift
//  ios-networking
//
//  Created by Khanh Anh Kiet on 2026-04-25.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel: PostViewModel
    
    init(viewModel: PostViewModel = PostViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PostViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        Task{
            let posts = try await viewModel.loadInitial()
            print(posts)
        }
    }
    
}
