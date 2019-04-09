//
//  PersistencyManager.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import RealmSwift

final class PersistencyManager {
    class func save(_ messageResponse: MessageResponse) {        
        NetworkProvider.shared.token = messageResponse.pageToken
        
        print(messageResponse.messages.last?.id)
       
        let realm = try! Realm()

        var messages = [Message]()

        messageResponse.messages.forEach { messageDTO in
            if realm.objects(Message.self).first(where: { $0.id == messageDTO.id }) == nil {
                let message = Message(messageDTO)
                messages.append(message)

                if messages.count == 20 {
                    saveInRealm(messages)
                    messages.removeAll()
                }
            }
        }
    }
    
    private class func saveInRealm( _ messages: [Message]) {
        DispatchQueue.global(qos: .userInteractive).async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(messages, update: true)
            }
            
            realm.refresh()
        }
    }
    
    class func clean() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    class func messages() -> Results<Message> {
        let realm = try! Realm()
        return realm.objects(Message.self)
    }
}


