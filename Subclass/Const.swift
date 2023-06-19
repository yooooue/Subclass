//
//  Const.swift
//  Subclass
//
//  Created by 韩倩云 on 2022/1/11.
//  Copyright © 2022 yy. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let IS_iPhoneX = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0 > 0.0
let NAVBAR_HEIGHT =  IS_iPhoneX ? 88.0 : 64.0
