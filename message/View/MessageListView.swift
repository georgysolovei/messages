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
//import RxRealmDataSources
import RealmSwift

class MessageListView: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var refreshToken: NotificationToken?

    var viewModel: MessageListType!
    
    private let disposeBag = DisposeBag()
//    private var dataSource: RxTableViewRealmDataSource<Message>!

    private struct Const {
        static let cellId = "MessageCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersistencyManager.clean()
        tableView.dataSource = self
        setupBindings()
    }
    
    private func setupBindings() {
//        dataSource = RxTableViewRealmDataSource<Message>(cellIdentifier: Const.cellId,
//                                                               cellType: MessageCell.self) { [unowned self] cell, indexPath, message in
//                                                                cell.message = message
//                                                                self.viewModel.cellForRow.onNext(indexPath)
//                                                            }
        
        refreshToken = viewModel.messageResults.observe(tableView.applyChanges)

        
        rx.viewWillAppear
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
//        viewModel.changeset
//            .do(onNext: { [weak self] changeset in
//                // Hide show empty label
//            })
//            .bind(to: tableView.rx.realmChanges(dataSource))
//            .disposed(by: disposeBag)
    }
}

extension MessageListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageResults.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRow.onNext(indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellId) as! MessageCell
        cell.message = viewModel.messageResults[indexPath.row]
        return cell
    }
}

extension UITableView {
    func applyChanges<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial: reloadData()
        case .update(let results, let deletions, let insertions, let updates):
            let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
            
            beginUpdates()
            insertRows(at: insertions.map(fromRow), with: .automatic)
            reloadRows(at: updates.map(fromRow), with: .automatic)
            deleteRows(at: deletions.map(fromRow), with: .automatic)
            endUpdates()
        case .error(let error): fatalError("\(error)")
        }
    }
}
