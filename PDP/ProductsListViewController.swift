//
//  ProductsListViewController.swift
//  PDP
//
//  Created by Paco Chacon de Dios on 17/12/17.
//  Copyright © 2017 Paco Chacon de Dios. All rights reserved.
//

import UIKit
import RealmSwift
import Crashlytics

class ProductsListViewController: UIViewController {

    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var toSaleLabel: UILabel!
    var products: [Product] = []
    let realm = try! Realm()
    var dummyVar: Int? = nil

    lazy var addProductButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: self.view.bounds.width - 70, y: self.view.bounds.height - 70, width: 50, height: 50))
        button.setAttributedTitle(NSAttributedString.init(string: "+", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25    , weight: .regular),
            NSAttributedStringKey.foregroundColor: UIColor.white
            ]), for: .normal)
        button.setAttributedTitle(NSAttributedString.init(string: "+", attributes: [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25, weight: .regular),
            NSAttributedStringKey.foregroundColor: UIColor.gray
            ]), for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = UIColor(red: 40 / 255, green: 147 / 255, blue: 250 / 255, alpha: 1)
        button.layer.cornerRadius = button.layer.bounds.height / 2
        button.addTarget(self, action: #selector(showAddProductPage(_:)), for: .touchUpInside)
        return button
    }()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(addProductButton)
        // Do any additional setup after loading the view.
    }

    func shareActionClick(_ message: String) {
        CLSLogv("Clicked on: %@", getVaList([message]))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI section
extension ProductsListViewController {

    func updateUI() {
        if !realm.isEmpty {
            let realmProducts = realm.objects(Product.self)
            products = realmProducts.map({ (product) -> Product in
                return product
            })
            updateQuantityLabels(using: products)
            tableView.reloadData()
        }
    }

    func updateQuantityLabels(using productsList: [Product]) {
        soldLabel.text = "$0"
        toSaleLabel.text = "$0"
        var sold: Int = 0
        var toSale: Int = 0
        for product in productsList {
            sold += product.soldQuantity * product.price
            toSale += (product.totalQuantity - product.soldQuantity) * product.price
        }
        DispatchQueue.main.async { [weak self] in
            self?.soldLabel.text = "$\(sold)"
            self?.toSaleLabel.text = "$\(toSale)"
        }
    }
}

// MARK: - View transitions section
extension ProductsListViewController {

    @objc func showAddProductPage(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Products", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "NewProductViewController")
        let navigation: UINavigationController = UINavigationController(rootViewController: vc)
        shareActionClick("open Add new product view")
        present(navigation, animated: true, completion: nil)
    }

}

extension ProductsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: "Borrar") { (action, view, boolean) in
            try! self.realm.write {
                self.realm.delete(self.products[indexPath.row])
            }
            self.products.remove(at: indexPath.row)
            self.updateQuantityLabels(using: self.products)
            tableView.reloadData()
        }
        let addAction: UIContextualAction = UIContextualAction(style: .normal, title: "+") { (action, view, bool) in
            let product = self.products[indexPath.row]
            if product.soldQuantity < product.totalQuantity {
                try! self.realm.write {
                    self.products[indexPath.row].soldQuantity += 1
                    self.realm.add(self.products[indexPath.row], update: true)
                }
                self.updateQuantityLabels(using: self.products)
                tableView.reloadData()
            }
        }
        addAction.backgroundColor = UIColor.green
        let reduceAction: UIContextualAction = UIContextualAction(style: .normal, title: "-") { (action, view, bool) in
            let product = self.products[indexPath.row]
            if product.soldQuantity > 0 {
                try! self.realm.write {
                    self.products[indexPath.row].soldQuantity -= 1
                    self.realm.add(self.products[indexPath.row], update: true)
                }
                self.updateQuantityLabels(using: self.products)
                tableView.reloadData()
            }
        }
        reduceAction.backgroundColor = UIColor.orange
        return UISwipeActionsConfiguration(actions: [deleteAction, reduceAction, addAction])
    }

}

extension ProductsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].name
        cell.detailTextLabel?.text = "Cantidad: \(products[indexPath.row].totalQuantity)-\(products[indexPath.row].soldQuantity)"
        cell.imageView?.image = UIImage(data: products[indexPath.row].image)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

}
