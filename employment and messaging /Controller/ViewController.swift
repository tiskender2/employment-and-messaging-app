//
//  ViewController.swift
//  Ortaklist
//
//  Created by MacMini on 25.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var girisBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var kSifre: UITextField!
    @IBOutlet weak var kAdi: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
     
      self.girisBtn.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        kSifre.resignFirstResponder()
        return (true)
    }
    @IBAction func btnGiris(_ sender: Any) {
        
        if((kAdi.text?.isEmpty)! || (kSifre.text?.isEmpty)!)
        {
            let alertView = UIAlertController(title: "Uyarı!", message: "Lütfen Boş Alan Bırakmayınız", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
        else
        {
            girisjson(urlString:"")
        }
    }
    
    func girisjson(urlString:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        let eposta=kAdi.text
        let sifre=kSifre.text
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
                        
                        if(durum == "")
                        {
                            
                            
                            DispatchQueue.main.async {
                                self.kAdi.text=""
                                self.kSifre.text=""
                                
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                next.loadView()
                                let nesne:MenuViewController=next.rearViewController as! MenuViewController
                                nesne.uyeid=uyeid!
                                let navViewController = next.frontViewController as! UINavigationController
                                if (navViewController.topViewController?.isKind(of: MainViewController.superclass()!))! {
                                    let mainVc = navViewController.topViewController as! MainViewController
                                    mainVc.listeID = "tamamlanmadi"
                                    mainVc.uyeId=uyeid!
                                }
                                self.present(next, animated: true, completion: nil)
                              
                                
                            }
                     
                            
                            
                        }
                        else if(durum=="")
                        {
                            DispatchQueue.main.async(execute: {
                                let alertView = UIAlertController(title: "Uyarı!", message: "KullanıcıAdı veya Şifre Yanlış!", preferredStyle: .alert)
                                alertView.addAction(UIAlertAction(title: "Tamam", style:.default, handler: nil))
                                self.present(alertView, animated: true, completion: nil)
                            })
               
                            
                        }
                            
                        else
                        {
                            print(durum!)
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

