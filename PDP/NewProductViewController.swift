//
//  NewProductViewController.swift
//  PDP
//
//  Created by Paco Chacon de Dios on 18/12/17.
//  Copyright © 2017 Paco Chacon de Dios. All rights reserved.
//

import UIKit
import RealmSwift

class NewProductViewController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    var imagePicker: UIImagePickerController!
    lazy var cancelButton: UIBarButtonItem = {
        let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancel(_:)))
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = cancelButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicture(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        guard productImage.image != nil else { return }
        guard !(nameTextField.text?.isEmpty)! else { return }
        guard !(priceTextField.text?.isEmpty)! else { return }
        guard !(quantityTextField.text?.isEmpty)! else { return }

        let resizedImage: UIImage = resizeImage(image: productImage.image!, targetSize: CGSize(width: 200, height: 300))
        let product: Product = Product(name: nameTextField.text!, totalQuantity: Int(quantityTextField.text!)!, price: Int(priceTextField.text!)!, image: UIImagePNGRepresentation(resizedImage) as Data!)
        try! realm.write {
            realm.add(product)
        }
        dismiss(animated: true, completion: nil)
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        productImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }

}
