//
//  MenuViewController.swift
//  Ortaklist
//
//  Created by MacMini on 25.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit
import FCAlertView

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SwiftAlertViewDelegate,UITextFieldDelegate,FCAlertViewDelegate{
   
    var menuIsım:Array=["Yapılacaklar","Tamamlananlar"]
    var uyeid:String=""
    var uyeIsım=""
    var resimtip:Array=["yapilacaklarxs","tamamlananxs"]
    var listeids:Array=[" "," "]
    var sahipids:Array=[" "," "]
    var listeid=""
    var index:Int=0
    var benimListe=""
    var timer = Timer()
    var time = 2.0
    var count=0
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userAd: UILabel!
    @IBOutlet weak var userBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userBtn.layer.cornerRadius=50
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.timer = Timer(timeInterval: 5.0, target: self, selector: #selector(MenuViewController.refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoopMode.defaultRunLoopMode)
        bilgijson(urlString: "")
        jsonveri(urlString: "")
              
    }
    @objc func loadList(notification: NSNotification){
            
            for index in stride(from: self.menuIsım.count-1, to: 1, by: -1) {
                self.menuIsım.remove(at: index)
                self.listeids.remove(at: index)
                self.sahipids.remove(at: index)
                self.resimtip.remove(at: index)
            }
        
        self.jsonveri(urlString: "")
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
           
        }
    }
    @objc func refresh()
    {
      jsonveri(urlString: "")
    }
    
   
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userAd.resignFirstResponder()
        return (true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        
    }
    func bilgijson(urlString:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        
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
                        let isim = jsonParse[""] as! String?
                        self.uyeIsım = isim!
                        if(durum == "")
                        {
                          
                            DispatchQueue.main.async(execute: {
                                self.userAd.text=isim!
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
   
    func jsonveri(urlString:String)
    {
        for index in stride(from: self.menuIsım.count-1, to: 1, by: -1) {
            self.menuIsım.remove(at: index)
            self.listeids.remove(at: index)
            self.sahipids.remove(at: index)
            self.resimtip.remove(at: index)
        }
        
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        
        let parameters = ""
       
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    if let jsonDic = json
                    {
                        for i in 0..<jsonDic.count
                        {
                            if let jsonVeri = jsonDic[i] as? NSDictionary
                            {
                                if let baslikArray = jsonVeri[""] as? String
                                {
                                    self.menuIsım.append(baslikArray)
                                }
                                if let resim = jsonVeri[""] as? String
                                {
                                    self.resimtip.append(resim)
                                
                                }
                                if let sahipid = jsonVeri[""] as? String
                                {
                                    self.sahipids.append(sahipid)
                                    
                                }
                                if let listeid = jsonVeri[""] as? String
                                {
                                    self.listeids.append(listeid)
                                    
                                }
                              
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                     
                    }
                }
                catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer)
    {
        let p = gestureReconizer.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: p)
        
        if indexPath == nil {
            print("long pres calışmadı")
        }
        else if (gestureReconizer.state == UIGestureRecognizerState.began) {
            if  sahipids[(indexPath?.row)!] == uyeid
            {
                benimListe=sahipids[(indexPath?.row)!]
                longPressAlert(title: "Uyari!", message: "Listeyi Silmek İstiyormusunuz?", button: "Listeyi Sil")
                listeid = listeids[(indexPath?.row)!]
                index=(indexPath?.row)!
                
            }
            else if indexPath?.row == 0 || indexPath?.row == 1 {
                
            }
            else
            {
                longPresBaskası(title: "Dikkat!", message: "Listeden Çıkmak İstiyormusunuz?", button: "Listeden Çık")
                listeid = listeids[(indexPath?.row)!]
                 index=(indexPath?.row)!
            
            }
        }
        
        
        
    }
    func longPressAlert(title:String,message:String,button:String)
    {
       
             let alertBenim = FCAlertView();
             alertBenim.delegate=self
            alertBenim.showAlert(inView: self,
                            withTitle:title,
                            withSubtitle:message,
                            withCustomImage: UIImage(named: "icon"),
                            withDoneButtonTitle:"İptal",
                            andButtons:["Listeyi Düzenle",button])

        }
    func longPresBaskası(title:String,message:String,button:String)
    {
        
        let alertBaskası = FCAlertView();
        alertBaskası.delegate=self
        alertBaskası.showAlert(inView: self,
                                withTitle:title,
                                withSubtitle:message,
                                withCustomImage: UIImage(named: "icon"),
                                withDoneButtonTitle:"İptal",
                                andButtons:[button])
    }
    
    func fcAlertView(_ alertView: FCAlertView, clickedButtonIndex iindex: Int, buttonTitle title: String) {
        
        if title == "Listeyi Sil" {
            listeSil(urlString:"")
            self.listeids.remove(at: index)
            self.sahipids.remove(at: index)
            self.menuIsım.remove(at: index)
            self.resimtip.remove(at: index)
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
            let revealViewController:SWRevealViewController = self.revealViewController()
            let mainStroyboard:UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let desController = mainStroyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            desController.btnMenuIsım.setTitle("Yapılacaklar", for: .normal)
            desController.listeID="tamamlanmadi"
            desController.uyeId=uyeid
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
           
           
        }else if title == "Listeden Çık" {
            listeSil(urlString:"")
            self.listeids.remove(at: index)
            self.sahipids.remove(at: index)
            self.menuIsım.remove(at: index)
            self.resimtip.remove(at: index)
            
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
            
            let revealViewController:SWRevealViewController = self.revealViewController()
            let mainStroyboard:UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let desController = mainStroyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            desController.btnMenuIsım.setTitle("Yapılacaklar", for: .normal)
            desController.listeID="tamamlanmadi"
            desController.uyeId=uyeid
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        }
        else if title == "Listeyi Düzenle"
        {
            var alertview:SwiftAlertView!
            let pass = Bundle.main.loadNibNamed("CustomAlert", owner:self, options: nil)?.first as? CustomAlertView
            pass?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-60, height:self.view.frame.height / 3.5)
            
            
            alertview = SwiftAlertView(contentView: pass)
            pass?.contentalertView(alertview)
            alertview.delegate=self
            alertview.setCornerRadius(10)
            alertview.dismissOnOutsideClicked = true
            pass?.delegate()
            pass?.listeId=listeid
            pass?.uyeid=uyeid
            pass?.listeDetayi(urlString: "", listeId: listeid)
            pass?.btnCreate.setTitle("DÜZENLE", for: .normal)
            pass?.isimLabel.text="Liste Düzenle"
            alertview.show()
            pass?.layoutIfNeeded()
            pass?.uyeid=uyeid
        }
    }
    func listeSil(urlString:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        
        let parameters = ""
        
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                
            }
            
        })
        task.resume()
    }
    
    @IBAction func userBtnAction(_ sender: Any)
    {
      alertGoster()
    }
    func alertGoster()
    {
        var alertview:SwiftAlertView!
        let pass = Bundle.main.loadNibNamed("CustomAlert", owner:self, options: nil)?.first as? CustomAlertView
        pass?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-60, height:self.view.frame.height / 3.5)
        
        
        alertview = SwiftAlertView(contentView: pass)
        pass?.contentalertView(alertview)
        alertview.delegate=self
        alertview.setCornerRadius(10)
        alertview.dismissOnOutsideClicked = true
        pass?.delegate()
        alertview.show()
        pass?.layoutIfNeeded()
        pass?.uyeid=uyeid
    }
  
   
   
    func touchDismissAlertView(_ alertView: SwiftAlertView) {
        print("sa")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuIsım.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"mycell") as! menuTableViewCell
            cell.menuLabel.text!=menuIsım[indexPath.row]
            cell.menuIcon.image = UIImage(named:"\(resimtip[indexPath.row])")
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MenuViewController.longTap))
        cell.addGestureRecognizer(longGesture)

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealViewController:SWRevealViewController = self.revealViewController()
        let cell:menuTableViewCell = tableView.cellForRow(at: indexPath) as! menuTableViewCell
       
            let mainStroyboard:UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
            let desController = mainStroyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            desController.btnMenuIsım.setTitle(menuIsım[indexPath.row], for: .normal)
            if cell.menuLabel.text == "Yapılacaklar"
            {
             
                desController.listeID = "tamamlanmadi"
               
            }
            else if cell.menuLabel.text == "Tamamlananlar"
            {
                
                 desController.listeID = "tamamlandi"
                
            }
            else
            {
                
                desController.listeID = listeids[indexPath.row]
            }
            desController.uyeId=uyeid
            desController.uyeIsım = uyeIsım
            let newFrontViewController = UINavigationController.init(rootViewController: desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
        
        
    }
    
    

}
