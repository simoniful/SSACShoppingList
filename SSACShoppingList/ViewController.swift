//
//  ViewController.swift
//  SSACShoppingList
//
//  Created by Sang hun Lee on 2021/11/02.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
    let localRealm = try! Realm()
    var shoppingList: Results<ShoppingItem>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
//    var list: [ShoppingList] = [] {
//        didSet {
//            print("List가 변경되었어요")
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: ShoppingTableViewCell.identifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        title = "쇼핑"
        shoppingList = localRealm.objects(ShoppingItem.self)
        tableView.reloadData()
        print("Realm is located at", localRealm.configuration.fileURL!)
    }

    @IBAction func addBtnClicked(_ sender: UIButton) {
        if inputText.text == "" {
            let alert = UIAlertController(title: "입력된 텍스트가 없습니다.", message: "할일을 입력해주세요", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        } else {
            let item = ShoppingItem(itemName: inputText.text!, checked: false, favorite: false, writeDate: Date(), regDate: Date())
            try! localRealm.write {
                localRealm.add(item)
            }
            // list.append(todo)
            tableView.reloadData()
            inputText.text = ""
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.identifier, for: indexPath) as? ShoppingTableViewCell else {
            return UITableViewCell()
        }
        let row = shoppingList[indexPath.row]
        
        cell.titleLabel.text = row.itemName
        
        cell.checkboxAction = { [unowned self] in
            self.shoppingList[indexPath.row].checked = !(self.shoppingList[indexPath.row].checked)
            self.shoppingList[indexPath.row].checked == true ? cell.checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : cell.checkbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        
        cell.favoriteBtnAction = { [unowned self] in
            self.shoppingList[indexPath.row].favorite = !(self.shoppingList[indexPath.row].favorite)
            self.shoppingList[indexPath.row].favorite == true ? cell.favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .normal) : cell.favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            shoppingList.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
}

