//
//  Item.swift
//  221 - Todoey
//
//  Created by KG Sasaki on 1/20/19.
//  Copyright © 2019 ABRIDGEA. All rights reserved.
//

import Foundation

class Item {
	var title	: String
	var done	: Bool

	init(title: String, done: Bool) {
		self.title = title
		self.done  = done
	}
}
