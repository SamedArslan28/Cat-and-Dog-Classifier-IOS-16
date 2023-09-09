//
//  ViewController.swift
//  imageClassification
//
//  Created by Abdulsamed Arslan on 8.09.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
      
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            detect(image: image)
        }
    }
    func detect(image:UIImage){
        
        if let model = try? MyImageClassifier_1(configuration:MLModelConfiguration()){
            do{
                let resized = image.resize(size: CGSize(width: 299, height: 299))
                let buffered = resized?.getCVPixelBuffer()
                let predictions = try model.prediction(image: buffered!)
                self.navigationItem.title=predictions.classLabel
                
            }
            
            catch{
                print("error")
            }
            
        }
        else{
            print("cannot find model")
            
            
        }
        
        
    }
    
}

