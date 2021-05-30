//
//  TextData.swift
//  Yometa
//
//  Created by 川上知宏 on 2021/05/31.
//

import Foundation
import RealmSwift

class Text: Object {
    @objc dynamic var title: String = ""
    let textWords = List<TextWord>()
    let registrationWords = List<RegistrationWord>()
    override static func primaryKey() -> String? {
            return "title"
        }
}

class TextWord: Object {
    @objc dynamic var textWord: String = ""
}

class RegistrationWord: Object {
    @objc dynamic var english: String = ""
    @objc dynamic var japanese: String = ""
}
