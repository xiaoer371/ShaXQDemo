//
//  Contact.swift
//  SHXQDemo2
//
//  Created by swhl on 16/3/4.
//  Copyright © 2016年 sprite. All rights reserved.
//

import UIKit

enum ContactState {
    case  ContactStateNormal
    case  ContactStateAdd
    case  ContactStateDel
}


class Contact: NSObject {
    var name :String?
    var headUrl :String?
    var state : ContactState?
    override init (){
        self.state = ContactState.ContactStateNormal
    }
}
