//
//  IDModel.swift
//  HeartBit
//
//  Created by Turma01-7 on 09/04/25.
//

import Foundation


    struct newFormData: Codable {
        var _id, _rev : String
        let name, cpf, rg, phone, naturalidade, address, neighborhood, city, postalCode, state: String
        let susCard, healthPlan, bloodType, doctorName, doctorPhone: String
        let emergencyContacts: [Contatos]
        let medicalHistory, allergyDetails, seizureDetails, feverMedication, surgeryDetails: String
        let isAllergic, hasSeizures, surgeryDone: Bool
        let birthDate: Date
        let healthIssues: [String: Bool]
}

