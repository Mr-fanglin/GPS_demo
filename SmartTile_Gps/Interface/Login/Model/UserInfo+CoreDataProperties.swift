//
//  UserInfo+CoreDataProperties.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/1.
//  Copyright © 2020 fanglin. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var address: String?
    @NSManaged public var birthDay: String?
    @NSManaged public var createDate: String?
    @NSManaged public var email: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Int32
    @NSManaged public var idaccount: Int32
    @NSManaged public var idnum: String?
    @NSManaged public var lastUpdate: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var sex: Int16
    @NSManaged public var token: String?

}
