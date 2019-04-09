//
//  ViewController.swift
//  message
//
//  Created by Georgy Solovei on 4/8/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealmDataSources

class MessageListView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MessageListType!
    
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewRealmDataSource<Message>!

    private struct Const {
        static let cellId = "MessageCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        dataSource = RxTableViewRealmDataSource<Message>(cellIdentifier: Const.cellId,
                                                               cellType: MessageCell.self) { [unowned self] cell, indexPath, message in
                                                                cell.message = message
                                                                self.viewModel.cellForRow.onNext(indexPath)
                                                            }
        
        
        rx.viewWillAppear
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.changeset
            .do(onNext: { [weak self] changeset in
                // Hide show empty label
            })
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
    }
}
