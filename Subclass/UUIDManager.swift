//
//  UUIDManager.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/9/13.
//  Copyright © 2022 yy. All rights reserved.
//

import UIKit
import Security
import CoreMedia

class UUIDManager: NSObject {
    
    static let KEY_USERNAME_PASSWORD = "com.imacco.subclass"

    static let KEY_PASSWORD = "com.imacco.subclass.uuid"
    
    static let manager = UUIDManager()
    
    private override init() {}
    
    @objc static func saveUUID(uuid: String) {
        var usernameUuidPairs = Dictionary<String, Any>()
        usernameUuidPairs[UUIDManager.KEY_PASSWORD] = uuid
        HHKeyChain.keyChainSaveData(data: usernameUuidPairs, withIdentifier: UUIDManager.KEY_USERNAME_PASSWORD)
    }
    
    @objc static func readUUID() -> Any? {
        let data = HHKeyChain.keyChainReadData(identifier: UUIDManager.KEY_USERNAME_PASSWORD)
        if let data = data as? Dictionary<String, Any> {
            return data[UUIDManager.KEY_PASSWORD]
        }
        return nil
    }
    
    @objc static func deleteUUID() {
        HHKeyChain.keyChianDelete(identifier: UUIDManager.KEY_USERNAME_PASSWORD)
    }
}
