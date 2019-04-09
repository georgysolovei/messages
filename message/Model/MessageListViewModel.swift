//
//  MessageListViewModel.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

protocol MessageListType: class {
    var viewWillAppear: AnyObserver<Void>                                                  { get }
    var cellForRow:     PublishSubject<IndexPath>                                          { get }
    var cellViewModel:  Observable<MessageCellViewModelType>                               { get }
//    var changeset:      Observable<(AnyRealmCollection<Message>, RxRealm.RealmChangeset?)> { get }
    var messageResults: Results<Message> { get }
}

final class MessageListViewModel: MessageListType {
    // Input
    let viewWillAppear: AnyObserver<Void>
    let cellForRow = PublishSubject<IndexPath>()

    // Output
//    let changeset: Observable<(AnyRealmCollection<Message>, RxRealm.RealmChangeset?)>
    let cellViewModel: Observable<MessageCellViewModelType>

    private let viewWillAppearSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let cellViewModelSubject = PublishSubject<MessageCellViewModelType>()
    let messageResults: Results<Message>

    private struct Const {
        static let leftCountTillEndFirst = 80
//        static let leftCountTillEndSecond = 20
    }
    
    init() {
        messageResults = PersistencyManager.messages()
//        changeset = Observable.changeset(from: messageResults)

        viewWillAppear = viewWillAppearSubject.asObserver()
        cellViewModel  = cellViewModelSubject.asObservable()

        viewWillAppearSubject.asObservable()
            .take(1)
            .subscribe(onNext: { [unowned self] in
//                PersistencyManager.clean()
                self.fetch()
            })
            .disposed(by: disposeBag)
        
        cellForRow.subscribe(onNext: { [unowned self] indexPath in
            let leftCount = self.messageResults.count - indexPath.row
           
            if  leftCount == Const.leftCountTillEndFirst /* || leftCount ==  Const.leftCountTillEndSecond */{
                self.fetch()
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func fetch() {
        NetworkProvider.shared.rx
            .requestData()
//            .debounce(0.2, scheduler: MainScheduler.instance)
//            .delay(1, scheduler: MainScheduler.instance)
//            .flatMap { _ in
//                return NetworkProvider.shared.rx.requestData()
//            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
