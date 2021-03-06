//
//  ViewController.swift
//  SSACShoppingList
//
//  Created by Sang hun Lee on 2021/11/02.
//

import UIKit
import RealmSwift


enum FilterStatus: Int {
    case basic, title, favorite, checked
}

class ViewController: UIViewController {
    let localRealm = try! Realm()
    var shoppingList: Results<ShoppingItem>!
    var filterStatus: FilterStatus = .basic
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
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
            tableView.reloadData()
            inputText.text = ""
        }
    }
    
    func changeFilterStatus(_ input:FilterStatus) {
        filterStatus = input
        switch filterStatus {
        case .basic, .title:
            shoppingList = localRealm.objects(ShoppingItem.self).sorted(byKeyPath: "itemName", ascending: true)
            tableView.reloadData()
        case .favorite:
            shoppingList = localRealm.objects(ShoppingItem.self).sorted(byKeyPath: "favorite", ascending: true)
            tableView.reloadData()
        case .checked:
            shoppingList = localRealm.objects(ShoppingItem.self).sorted(byKeyPath: "checked", ascending: true)
            tableView.reloadData()
        }
    }
    
    @IBAction func filterBtnClicked(_ sender: UIButton) {
        // 1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2. UIAlertAction 생성: 버튼들..
        let title = UIAlertAction(title: "제목순", style: .default, handler: {(action: UIAlertAction!) in self.changeFilterStatus(.title)})
        let favorite = UIAlertAction(title: "완료순", style: .default, handler:{(action: UIAlertAction!) in self.changeFilterStatus(.favorite)})
        let checked = UIAlertAction(title: "즐겨찾기순", style: .default, handler:{(action: UIAlertAction!) in self.changeFilterStatus(.checked)})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler:nil)
        
        // 3. 1+2
        alert.addAction(title)
        alert.addAction(favorite)
        alert.addAction(checked)
        alert.addAction(cancel)
        
        // 4. Present
        present(alert, animated: true, completion: nil)
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
            try! localRealm.write {
                row.checked = !(row.checked)
                tableView.reloadData()
             }
        }
        row.checked == true ? cell.checkbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : cell.checkbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        
        cell.favoriteBtnAction = { [unowned self] in
            try! localRealm.write {
                row.favorite = !(row.favorite)
                tableView.reloadData()
             }
        }
        row.favorite == true ? cell.favoriteBtn.setImage(UIImage(systemName: "star.fill"), for: .normal) : cell.favoriteBtn.setImage(UIImage(systemName: "star"), for: .normal)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        try! localRealm.write {
            let row = shoppingList[indexPath.row]
            localRealm.delete(row)
            tableView.reloadData()
        }
    }
}

