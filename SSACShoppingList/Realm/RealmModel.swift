//
//  RealmModel.swift
//  SSACShoppingList
//
//  Created by Sang hun Lee on 2021/11/02.
//

import Foundation
import RealmSwift

// 스키마, 테이블, 컬럼
// 1. 테이블 이름 변경
class ShoppingItem: Object {
    // 2. 각 컬럼 정립
    // 3. PK키 구성
    @Persisted(primaryKey: true) var _id: ObjectId // AutoIncreasement
    @Persisted var itemName: String
    @Persisted var checked: Bool
    @Persisted var favorite: Bool
    @Persisted var writeDate = Date()
    @Persisted var regDate = Date()
    

    convenience init(itemName: String, checked: Bool, favorite: Bool, writeDate: Date, regDate: Date) {
        self.init()
        
        self.itemName = itemName
        self.checked = false
        self.writeDate = writeDate
        self.regDate = regDate
        self.favorite = false
    }
}
