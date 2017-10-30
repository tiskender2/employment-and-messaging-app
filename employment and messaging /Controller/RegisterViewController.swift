//
//  RegisterViewController.swift
//  Ortaklist
//
//  Created by MacMini on 25.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var kayitBtn: UIButton!
    @IBOutlet weak var resifre: UITextField!
    @IBOutlet weak var sifre: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var adSoyad: UITextField!
    @IBOutlet weak var kAdi: UITextField!
    @IBOutlet weak var icon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        self.kayitBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnKayıt(_ sender: Any) {
        
        if(sifre.text != resifre.text)
        {
            let alertView = UIAlertController(title: "Uyarı!", message: "Şifreler Aynı Olmak Zorunda", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
        
       else if((kAdi.text?.isEmpty)! || (adSoyad.text?.isEmpty)! || (email.text?.isEmpty)!
        || (sifre.text?.isEmpty)! || (resifre.text?.isEmpty)!)
        {
            let alertView = UIAlertController(title: "Uyarı!", message: "Lütfen Boş Alan Bırakmayınız", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
   
        else{
            kayitjson(urlString: "")
        }
       
    }
    func kayitjson(urlString:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        let kAdi=self.kAdi.text
        let sifre=self.sifre.text
        let eposta=self.email.text
        let isim=self.adSoyad.text
        let parameters = ""
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
                
            else
            {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let jsonParse = json{
                        let durum = jsonParse[""] as! String?
                        let uyeid = jsonParse[""] as! String?
                        
                        switch durum
                        {
                        case ""?:
                            print(durum!)
                            print(uyeid!)
                            
                            DispatchQueue.main.async {
                                self.kAdi.text=""
                                self.adSoyad.text=""
                                self.sifre.text=""
                                self.resifre.text=""
                                self.email.text=""
                            }
                            break
                        case ""?:
                            
                            let alertView = UIAlertController(title: "Uyarı!", message: "Böyle Bir Uye Var", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
                            self.present(alertView, animated: true, completion: nil)
                            break
                            
                        case ""?:
                            let alertView = UIAlertController(title: "Uyarı!", message: "Eposta Formati Yanlış", preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
                            self.present(alertView, animated: true, completion: nil)
                            break
                       
                        case .none:
                            print("a")
                        case .some(_):
                            print("b")
                        }
                        
                      
                        
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    

}
