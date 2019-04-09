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
import RxDataSources

protocol MessageListType: class {
    var viewWillAppear: AnyObserver<Void>                    { get }
    var cellForRow:     PublishSubject<Int>                  { get }
    var cellViewModel:  Observable<MessageCellViewModelType> { get }
    var cellViewModelArray: Observable<[SectionModel<String, MessageDTO>]>         { get }
    var showBanner: Observable<Bool> { get }
    var reload: AnyObserver<Void> { get }
    var loadMore: AnyObserver<Void> { get }
}

final class MessageListViewModel: MessageListType {
    
    // Input
    let viewWillAppear: AnyObserver<Void>
    let cellForRow = PublishSubject<Int>()
    let reload: AnyObserver<Void>
    let loadMore: AnyObserver<Void>

    private var messageArray = [MessageDTO]()
    
    // Output
    let cellViewModel: Observable<MessageCellViewModelType>
    let cellViewModelArray: Observable<[SectionModel<String, MessageDTO>]>
    let showBanner: Observable<Bool>

    private let viewWillAppearSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let cellViewModelSubject = PublishSubject<MessageCellViewModelType>()
    private let cellViewModelArraySubject = PublishSubject<[SectionModel<String, MessageDTO>]>()
    private let showBannerSubject = PublishSubject<Bool>()
    private let reloadSubject = PublishSubject<Void>()
    private var bannerShowDate = Date()
    private let loadMoreSubject = PublishSubject<Void>()

    private struct Const {
        static let leftCountTillEndFirst = 80
        static let leftCountTillEndSecond = 1
    }
    
    init() {

        viewWillAppear = viewWillAppearSubject.asObserver()
        cellViewModel  = cellViewModelSubject.asObservable()
        showBanner     = showBannerSubject.asObservable()
        reload         = reloadSubject.asObserver()
        loadMore       = loadMoreSubject.asObserver()
        
        cellViewModelArray = cellViewModelArraySubject.asObservable()
        
        viewWillAppearSubject.asObservable()
            .take(1)
            .subscribe(onNext: { [unowned self] in
                self.fetch()
            })
            .disposed(by: disposeBag)
        
        cellForRow
            .filter { index in
                let leftCount = self.messageArray.count - index

                return  leftCount == Const.leftCountTillEndFirst
                    || leftCount ==  Const.leftCountTillEndSecond
            }
            .throttle(0.4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] index in
                self.fetch()
        })
            .disposed(by: disposeBag)
        
        reloadSubject.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                NetworkProvider.shared.token = ""
                self.messageArray.removeAll()
                let sectionModel = SectionModel(model: "", items: self.messageArray)
                self.cellViewModelArraySubject.onNext([sectionModel])
                self.bannerShowDate = Date.distantPast
                self.fetch()
            }
            .disposed(by: disposeBag)
        
        loadMoreSubject.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.bannerShowDate = Date.distantPast
                self?.fetch()
            })
            .disposed(by: disposeBag)
    }
    
    private func fetch() {
        
        NetworkProvider.shared.rx
            .requestData()
            .subscribe(onNext: { [weak self] messageResponse in
                guard let `self` = self, let messages = messageResponse?.messages else { return }
                self.showBannerSubject.onNext(false)

                if let message = messages.first {
                    if !self.messageArray.contains(where: { $0.id == message.id}) {
                        
                        self.messageArray.append(contentsOf: messages)
                        let sectionModel = SectionModel(model: "", items: self.messageArray)
                        self.cellViewModelArraySubject.onNext([sectionModel])
                    }
                }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    if (Date().timeIntervalSince1970 - self.bannerShowDate.timeIntervalSince1970) > TimeInterval(5) {
                        self.showBannerSubject.onNext(true)
                        self.bannerShowDate = Date()
                    }
            })
            .disposed(by: disposeBag)
    }
}

