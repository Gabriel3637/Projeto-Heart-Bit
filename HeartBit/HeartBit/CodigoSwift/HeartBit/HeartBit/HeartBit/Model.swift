
//
//  Model.swift
//  trabaio
//
//  Created by Turma01-15 on 03/04/25.
//

import Foundation

struct bpm: Decodable, Identifiable{
    let _id: String
    let _rev: String
    let batimento: Int?
    let data: Int?
    var id: String {_id}
}
