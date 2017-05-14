//
//  ViewController.swift
//  ISBN
//
//  Created by Mac Juan Araiza on 05/05/17.
//  Copyright © 2017 Juan Araiza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var resultado: UITextView!
    
    
    @IBAction func limpiar(_ sender: Any) {
        self.isbn.text=""
        self.resultado.text=""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buscar(_ sender: Any) {
        self.resultado.text = sincrono(isbn : self.isbn.text!)
    }
    @IBAction func enterBuscar(_ sender: Any) {
         self.resultado.text = sincrono(isbn : self.isbn.text!)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBuscar(_ sender: Any) {
        
        self.resultado.text = sincrono(isbn : self.isbn.text!)
        
        
    }
    func sincrono(isbn : String) -> String{
        let urls="https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        /*let url = URL(string: urls)
        let datos:NSData? = NSData(contentsOf: url!)
        let texto = NSString(data:datos! as Data, encoding:String.Encoding.utf8.rawValue)!
        */
        var texto = ""
        let url = NSURL(string: urls)
        let datos = NSData(contentsOf: url! as URL)
        do{
            let json = try JSONSerialization.jsonObject(with: datos! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
            let dico1 = json as! NSDictionary
            if (dico1["ISBN:\(isbn)"] == nil){
                texto = "\(texto) \n No hay datos para este ISBN"
            }else{
            let dico2 = dico1["ISBN:\(isbn)"] as! NSDictionary
            texto = "Titulo: \(dico2["title"] as! NSString as String)"
            if (dico2["authors"] == nil){
                texto = "\(texto) \n No se encontraron Autores"
            }else{
                let dico3 = dico2["authors"] as! NSArray
                var dico4 : NSDictionary
                for i in 0..<dico3.count {
                    dico4 = dico3[i] as! NSDictionary
                    texto = "\(texto) \n Autor \(i+1): \(dico4["name"] as! NSString as String)"
                }

            }
            
            if (dico2["authors"] == nil){
                texto = "\(texto) \n No se encontro imagen del Libro"
            }else{
            let dico5 = dico2["cover"] as! NSDictionary
            let urli = NSURL(string:"\(dico5["large"] as! NSString as String)")
            let data = NSData(contentsOf:urli! as URL)
            if data != nil {
                self.imagen.image = UIImage(data:data! as Data)
            }
            }
            }
        }catch _ {
            
        }

      
        return texto as String
        
        
    }
    

}

