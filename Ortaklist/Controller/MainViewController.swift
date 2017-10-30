//
//  MainViewController.swift
//  Ortaklist
//
//  Created by MacMini on 25.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit
import FCAlertView
class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BEMCheckBoxDelegate,SwiftAlertViewDelegate,FCAlertViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnGorev: UIBarButtonItem!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var btnMenuIsım: UIButton!
    var listeID=""
    var listeId2=""
    var uyeId=""
    var uyeIsım=""
    var gorevid=""
    var index = 0
    var height = CGFloat()
    var timer = Timer()
    var gorevIsım=[String]()
    var yuzde=[Int]()
    var yuzdeControl=[Int]()
    var yuzderengi=[String]()
    var durum=[String]()
    var gorevId=[String]()
    var yenileBack=0
    var size = CGFloat()
    var tip = ""
    var isim=[String]()
    var ePosta=[String]()
    var kAdi=[String]()
    var gorevSahipId=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        gorevCek(urlString: "")
        print(listeId2,"a")
        self.timer = Timer(timeInterval: 5.0, target: self, selector: #selector(MainViewController.refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoopMode.defaultRunLoopMode)
        if btnMenuIsım.titleLabel?.text == "Yapılacaklar" || btnMenuIsım.titleLabel?.text == "Tamamlananlar"
        {
            btnGorev.isEnabled = false
            btnGorev.image=nil
        }
        btnMenu.target=revealViewController()
        btnMenu.action=#selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
          let cell = tblView.dequeueReusableCell(withIdentifier:"mycell") as! MainTableViewCell
          size = cell.arkaPlan.frame.size.width
          cell.checkBox.delegate=self
        gorevlendirelecekler(urlString: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh()
    {
          gorevCek(urlString: "")
    }
   
    @IBAction func btnGorevEkle(_ sender: Any) {

        var alertview:SwiftAlertView!
        let pass = Bundle.main.loadNibNamed("CustomGorevEkle", owner:self, options: nil)?.first as? GorevEkle
        pass?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-60, height:self.view.frame.height / 1.4)
       
       if self.tip == "paylasilan"
        {
             pass?.frame.size.height = self.view.frame.height / 1.4
        }
        else
        {
             pass?.frame.size.height=(self.view.frame.height / 1.4)-108
        }
    
        alertview = SwiftAlertView(contentView: pass)
        pass?.contentalertView(alertview)
        alertview.delegate=self
        alertview.setCornerRadius(5)
        alertview.dismissOnOutsideClicked = false
        pass?.uyeId=uyeId
        pass?.listeID=listeID
        pass?.calıstır()
        pass?.baslıkLabel.text = "'"+(btnMenuIsım.titleLabel?.text)!+"' Listesine Görev Ekle"
        pass?.detayText.borderStyle = UITextBorderStyle.roundedRect
        pass?.scrollView.contentSize.height = 300
        alertview.show()
     
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gorevIsım.count == 0
        {
            indicator.stopAnimating()
        }
        return gorevIsım.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier:"mycell") as! MainTableViewCell
       
        cell.lbl.text=gorevIsım[indexPath.row]
      
      
        cell.arkaPlan.frame.size.width=(size * CGFloat(yuzde[indexPath.row]*10))/100
    
    
        if durum[indexPath.row]=="tamamlandi"
        {
           cell.checkBox.setOn(true, animated: true)
          
        }
        else
        {
            cell.checkBox.setOn(false, animated: true)
        }
        cell.arkaPlan.backgroundColor=hexStringToUIColor(hex: yuzderengi[indexPath.row])
        cell.checkBox.tag = indexPath.row
        indicator.stopAnimating()
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.longTap))
        cell.addGestureRecognizer(longGesture)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nesne = storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        nesne.mesajBaslık.setTitle(gorevIsım[indexPath.row], for: .normal)
        nesne.senderId = uyeId
        nesne.senderDisplayName=uyeIsım
        nesne.gorevId=gorevId[indexPath.row]
        navigationController?.pushViewController(nesne, animated: true)
        
    }
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer)
    {
        let p = gestureReconizer.location(in: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: p)
        
        if indexPath == nil {
            print("long pres calışmadı")
        }
        else if (gestureReconizer.state == UIGestureRecognizerState.began)
        {
            if gorevSahipId[(indexPath?.row)!] == uyeId
            {
                longPressAlert(title: "Uyarı!", message: "Görevi İptal Etmek İstiyormusunuz?", button: "Görevi İptal Et")
                gorevid = gorevId[(indexPath?.row)!]
                index   = (indexPath?.row)!
                
            }
            else
            {
                longPresBaskası(title: "Dikkat!", message: "Görevden Çıkmak İstiyormusunuz?", button: "Görevden Çık")
                gorevid = gorevId[(indexPath?.row)!]
                index   = (indexPath?.row)!
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
                             andButtons:["Görevi Düzenle",button])
        
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
    
    func fcAlertView(_ alertView: FCAlertView!, clickedButtonIndex iindex: Int, buttonTitle title: String!) {
        
        if title == "Görevi İptal Et"
        {
           
           gorevdenCık(urlString: "" )
            self.gorevId.remove(at: index)
            self.gorevIsım.remove(at: index)
            self.yuzde.remove(at: index)
            self.yuzderengi.remove(at: index)
            self.durum.remove(at: index)
            self.gorevSahipId.remove(at: index)
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
          
        }
        else if title == "Görevden Çık"
        {
           gorevdenCık(urlString: "" )
            self.gorevId.remove(at: index)
            self.gorevIsım.remove(at: index)
            self.yuzde.remove(at: index)
            self.yuzderengi.remove(at: index)
            self.durum.remove(at: index)
            self.gorevSahipId.remove(at: index)
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
        }
        else if title == "Görevi Düzenle"
        {
            
            var alertview:SwiftAlertView!
            let pass = Bundle.main.loadNibNamed("CustomGorevEkle", owner:self, options: nil)?.first as? GorevEkle
            pass?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-60, height:self.view.frame.height / 1.4)
            alertview = SwiftAlertView(contentView: pass)
            pass?.contentalertView(alertview)
            alertview.delegate=self
            alertview.setCornerRadius(5)
            alertview.dismissOnOutsideClicked = false
            pass?.createBtn.setTitle("DÜZENLE", for: .normal)
            pass?.gorevId=gorevid
            pass?.uyeId=uyeId
            
            pass?.gorevDuzenleme()
            pass?.baslıkLabel.text = "'"+(btnMenuIsım.titleLabel?.text)!+"' Listesini Düzenle"
            pass?.detayText.borderStyle = UITextBorderStyle.roundedRect
            pass?.scrollView.contentSize.height = 300
           
            
            alertview.show()
            
           DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
        }
        
    }
    
   
    
    func didTap(_ checkBox: BEMCheckBox) {
        
        print("asd",checkBox.tag,checkBox.on,gorevId[checkBox.tag])
        if checkBox.on == true
        {
       
            checkbox(urlString: "",gorevid:gorevId[checkBox.tag],durum: "tamamlandi")
            gorevCek(urlString: "")
            
        }
        else
        {
             checkbox(urlString: "",gorevid:gorevId[checkBox.tag],durum: "tamamlanmadi")
             gorevCek(urlString: "")
            
        }
    }
    
    func gorevdenCık(urlString:String)
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
                print("başarılı")
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
        })
        task.resume()
    }
    
    func gorevCek(urlString:String)
    {
        gorevIsım.removeAll()
        yuzdeControl.removeAll()
        yuzde.removeAll()
        yuzdeControl=yuzde
        yuzderengi.removeAll()
        durum.removeAll()
        gorevId.removeAll()
     
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
                                    self.gorevIsım.append(baslikArray)
                                    
                                }
                                if let gecenyuzde = jsonVeri[""] as? Int
                                {
                                    self.yuzde.append(gecenyuzde)
                                
                                  
                                }
                                if let renk = jsonVeri[""] as? String
                                {
                                    self.yuzderengi.append(renk)
                                    
                                }
                                if let durum = jsonVeri[""] as? String
                                {
                                    self.durum.append(durum)
                                    
                                }
                                if let gorevid = jsonVeri[""] as? String
                                {
                                    self.gorevId.append(gorevid)
                                    
                                }
                                if let gorevSahip = jsonVeri[""] as? String
                                {
                                    self.gorevSahipId.append(gorevSahip)
                                    
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
    
    func gorevlendirelecekler(urlString:String)
    {
        isim.removeAll()
        ePosta.removeAll()
        kAdi.removeAll()
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
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    if let tib = json[""] as? String
                    {
                        self.tip=tib
                        
                    }
                    
                    DispatchQueue.main.async {
                    if self.tip == "paylasilan"
                    {
                        self.height=self.view.frame.height / 1.4
                    }
                    else
                    {
                        self.height=(self.view.frame.height / 1.4)-108
                    }
                    }
                    
                    
                }
                catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    func checkbox(urlString:String,gorevid:String,durum:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let parameters = "8"
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                 print("asda")
                }
            DispatchQueue.main.async {
                self.tblView.reloadData()
                
            }
        })
        task.resume()
    }
    
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
