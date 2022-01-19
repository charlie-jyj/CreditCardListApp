//
//  CreditCard.swift
//  CreditCardList
//
//  Created by UAPMobile on 2022/01/19.
//

import Foundation

struct CreditCard:Codable {
    let id: Int
    let rank: Int
    let name: String
    let promotionDetail: PromotionDetail
    let cardImageURL: String
    let isSelected: Bool?
    
}

struct PromotionDetail:Codable {
    let companyName: String
    let amount: Int
    let period: String
    let benefitDate: String
    let benefitDetail: String
    let benefitCondition: String
    let condition: String
}
