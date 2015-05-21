//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Vince Chan on 5/17/15.
//  Copyright (c) 2015 Vince Chan. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    var filePathUrl: NSURL!
    var title: String!
}