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
import RxDataSources
import NotificationBannerSwift

class MessageListView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bubble: UIImageView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    var viewModel: MessageListType!
    
    private let disposeBag = DisposeBag()
    private var banner: NotificationBanner!

    private struct Const {
        static let cellId = "MessageCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        banner = NotificationBanner(title: "Error", subtitle: "Try again later", style: .danger)
        banner.applyStyling(titleTextAlign: .center, subtitleTextAlign: .center)
    }
    
    private func setupBindings() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MessageDTO>>(configureCell: { [unowned self] dataSource, tableView, indexPath, item in
            
            self.viewModel.cellForRow.onNext(indexPath.row)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            cell.message = item
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        viewModel.cellViewModelArray
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        
        rx.viewWillAppear
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        
        viewModel.cellViewModelArray
            .map { return !($0.first?.items.isEmpty ?? true) }
            .bind(to: bubble.rx.isHidden.asObserver())
            .disposed(by: disposeBag)
        
        reloadButton.rx.tap
            .do(onNext: { [unowned self] in
                self.loadMoreButton.isHidden = true
                self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)

            })
            .asObservable()
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        viewModel.showBanner
            .debounce(1, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive(onNext:{ [unowned self] isShow in
                if isShow {
                    self.banner.show(bannerPosition: .bottom)
                } else {
                    self.banner.dismiss()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showBanner
            .delay(1, scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: true)
            .map(!)
            .map { [unowned self] isShow in
                if self.tableView.visibleCells.isEmpty {
                    return true
                } else {
                    return isShow
                }
            }
            .drive(loadMoreButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        loadMoreButton.rx.tap.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: true)
            .drive(loadMoreButton.rx.isHidden)
            .disposed(by: disposeBag)
        
         loadMoreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.loadMore)
            .disposed(by: disposeBag)

    }
}

struct Section {
    var header: String
    var items: [Item]
}

extension Section: SectionModelType {
    typealias Item = MessageDTO
    
    init(original: Section, items: [MessageDTO]) {
        self = original
        self.items = items
    }
}
