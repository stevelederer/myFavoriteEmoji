//
//  EmojiTextField.swift
//  myFavoriteEmoji
//
//  Created by Steve Lederer on 12/12/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class EmojiTextField: UITextField {

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
