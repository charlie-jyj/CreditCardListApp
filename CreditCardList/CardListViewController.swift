//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by UAPMobile on 2022/01/19.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

class CardListViewController: UITableViewController {
    var ref: DatabaseReference!
    var creditCardList: [CreditCard] = []
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        // Firebase database 인스턴스 생성
        ref = Database.database().reference()
        
        // reference 가 지켜보고 있다
//        ref.observe(.value) {
//            snapshot in
//            guard let value = snapshot.value as? [String: [String: Any]] else { return }
//            // casting 잘 해주지 않으면 nil 방출될 것
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                let cardData = try JSONDecoder().decode([String:CreditCard].self, from: jsonData)
//                let cardList = Array(cardData.values)
//                self.creditCardList = cardList.sorted {
//                    $0.rank < $1.rank
//                }
//
//                DispatchQueue.main.async{
//                    self.tableView.reloadData() // 가져온 데이터 표현
//                }
//
//            } catch let error {
//                print("\(error.localizedDescription)")
//            }
//        }
        
        // firestore
        db.collection("creditCardList").addSnapshotListener {
            snapshot, error in
            guard let documents = snapshot?.documents else {
                print("ERROR Firestore fetching document \(String(describing:error))")
                return
            }
            
            self.creditCardList = documents.compactMap {
                doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error {
                    print("EFFOR JSON Parsing \(error)")
                    return nil
                }
            }.sorted {
                $0.rank < $1.rank
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
  
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(self.creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(self.creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(self.creditCardList[indexPath.row].name)"
        
        // kingfisher
        let imageURL = URL(string: self.creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let cardDetailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        cardDetailViewController.promotionDetail = self.creditCardList[indexPath.row].promotionDetail
        
        let cardID = self.creditCardList[indexPath.row].id
        
        // key값을 특정할 수 있을 때
//        self.ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // 쿼리문을 통해 특정
//        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {
//            [weak self] snapshot in
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String:Any]],
//                  let key = value.keys.first else { return }
//            self.ref.child("\(key)/isSelected").setValue(true)
//        }
        
        
        // firestore
        // 경로를 알고 있을 때
//        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected":true])
        
        // 쿼리 사용
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments {
            snapshot, _ in
            guard let document = snapshot?.documents.first else {
                print("ERROR Firestore fetching document")
                return
            }
            
            document.reference.updateData(["isSelected":true])
        }
        
        self.show(cardDetailViewController, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Option1
            let cardID = self.creditCardList[indexPath.row]
//            ref.child("Item\(cardID)").removeValue()
            
            // Option2
//            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {
//                [weak self] snapshot in
//                guard let self = self,
//                      let entries = snapshot.value as? [String: [String: Any]],
//                      let key = entries.keys.first else { return }
//                self.ref.child("\(key)").removeValue()
//            }
            
            // Firestore
            
            // Option1
            db.collection("creditCardList").document("card\(cardID)").delete()
            
            // Option2
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments {
                snapshot, _ in
                guard let document = snapshot?.documents.first else { return }
                document.reference.delete()
            }
        }
    }
}
