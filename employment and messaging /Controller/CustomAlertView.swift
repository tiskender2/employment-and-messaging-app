//
//  CustomAlertView.swift
//  Ortaklist
//
//  Created by MacMini on 26.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class CustomAlertView:UIView,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate{
    
    var timer = Timer()
   
    @IBOutlet weak var pckerView: UIPickerView!
 
    let nesne=MenuViewController()
    var isim=[String]()
    var kulAdi=[String]()
    var kulEposta=[String]()
    var kAdiCount=[Int]()
    var isimDizi=[String]()
    var deger2=""
    var deger3=""
    var  deger = ""
    var kulAdiTm=""
    var gonderDeger=""
    var baslik=""
    var kullanicilar=""
    var parameters = ""
    var listeId=""
    var sil = 0
    @IBOutlet weak var listeAd: UITextField!
    @IBOutlet weak var kisiler: UITextField!
    var uyeid:String = ""
    var degisken:String = ""
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var isimLabel: UILabel!
    var uyeAd:String = ""
    var uyeEposta:String = ""
    var uyeKadi:String = ""
    var alertSwift:SwiftAlertView!
    var menu:MenuViewController!
    func contentalertView(_ alert: SwiftAlertView)
    {
        self.alertSwift = alert
        
        
    }
   
    @IBAction func btnAction(_ sender: Any) {
           self.alertSwift.dismiss()
 
    }
    @IBAction func btnCreate(_ sender: Any) {
        baslik=listeAd.text!
        kullanicilar=kisiler.text!
        if btnCreate.titleLabel?.text == "DÜZENLE"
        {
            jsonveri(urlString: "")
            self.alertSwift.dismiss()
        }
        else
        {
        if baslik != ""
        {
             self.timer = Timer(timeInterval: 2.0, target: self, selector: #selector(CustomAlertView.refresh), userInfo: nil, repeats: true)
             RunLoop.main.add(self.timer, forMode: RunLoopMode.defaultRunLoopMode)
           
             jsonveri(urlString: "")
            
            self.alertSwift.dismiss()
            
        }
        }
        
    }
    @objc func refresh()
    {
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
       
        self.timer.invalidate()
        
    }
    
    func listeDetayi(urlString:String,listeId:String)
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
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                 
                    if let listeAdı = json[""] as? String
                    {
                        DispatchQueue.main.async {
                            self.listeAd.text=listeAdı
                        }
                    }
                    if let listedekiler = json[""] as? String
                    {
                        
                        DispatchQueue.main.async {
                            
                            self.kisiler.text=listedekiler
                            
                            self.deger2=listedekiler
                        }
                    }
                    if let jsonDic = json[""] as! NSArray?
                    {
                        for i in 0..<jsonDic.count
                        {
                            let intdeger = jsonDic[i] as! String
                            self.kAdiCount.append(Int(intdeger)!)
                            DispatchQueue.main.async {
                              
                                self.degisken=self.kisiler.text!
                            }
                           
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
   
    func jsonveri2(urlString:String)
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
                                    self.nesne.menuIsım.append(baslikArray)
                                }
                                if let resim = jsonVeri[""] as? String
                                {
                                    self.nesne.resimtip.append(resim)
                                    
                                }
                                if let sahipid = jsonVeri[""] as? String
                                {
                                    self.nesne.sahipids.append(sahipid)
                                    
                                }
                                if let listeid = jsonVeri[""] as? String
                                {
                                    self.nesne.listeids.append(listeid)
                                    
                                }
                                
                                
                            }
                            
                            
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
   
    @IBAction func editText(_ sender: Any) {
        deger = kisiler.text!
        kisiler.text=deger
        if  (deger=="")
        {
           alertSwift.frame.size.height = self.frame.height-pckerView.frame.size.height
           
            isim.removeAll()
            DispatchQueue.main.async {
                self.pckerView.reloadAllComponents()
            }
        }
        
        if deger.characters.count >= deger2.characters.count
        {
        
        if deger.characters.count >= 4
        {
            let index = deger.index(deger.startIndex, offsetBy: self.deger2.characters.count)
            gonderDeger=String(deger[index...])
            if gonderDeger.characters.count >= 4
            {
                ekleJson(urlString: "",text: gonderDeger)
                
            }
            else{
                   alertSwift.frame.size.height = self.frame.height-pckerView.frame.size.height
            }
            }
        else
        {
           alertSwift.frame.size.height = self.frame.height-pckerView.frame.size.height
        }
        }
        else  {
            deger2=deger
            degisken=deger
           
           
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isim.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 65
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        
        let toplabel = UILabel(frame: CGRect(x: 0, y: 10, width: 250, height: 15))
        toplabel.text = isim[row]
        toplabel.textAlignment = .center
        toplabel.font=UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        view.addSubview(toplabel)
        let middLabel = UILabel(frame: CGRect(x: 0, y: 25, width: 250, height: 25))
        middLabel.text = "@"+kulAdi[row]
        middLabel.textAlignment = .center
        toplabel.font=UIFont.systemFont(ofSize: 55, weight: UIFont.Weight.thin)
        view.addSubview(middLabel)
        let bottomLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 250, height: 25))
        bottomLabel.text = kulEposta[row]
        bottomLabel.textAlignment = .center
        toplabel.font=UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        view.addSubview(bottomLabel)
        return view
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
       
        if self.deger>=degisken
        {
            if btnCreate.titleLabel?.text == "DÜZENLE"
            {
                
                kulAdiTm=kulAdi[row]+", "
                
                degisken=deger2+kulAdiTm
                kisiler.text=degisken
                deger2=degisken
                
            }
            else
            {
                kulAdiTm=kulAdi[row]+", "
                degisken=degisken+kulAdiTm
                kisiler.text=degisken
                deger2=degisken
                
            }
           
          
           
            alertSwift.frame.size.height = self.frame.height-pckerView.frame.size.height
            kAdiCount.append(kulAdiTm.count)
            isim.removeAll()
            DispatchQueue.main.async {
                self.pckerView.reloadAllComponents()
            }
        }
        else{
          
            isim.removeAll()
            print("1")
            DispatchQueue.main.async {
                self.pckerView.reloadAllComponents()
            }
        }
        
     
       
        
        
    }
    
 
    func jsonveri(urlString:String)
    {
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        if btnCreate.titleLabel?.text == "DÜZENLE"
        {
            parameters = ""
            
        }
        else
        {
        
            parameters = ""
        }
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
               print("basarili")
            }
            
        })
        task.resume()
    }

    func ekleJson(urlString:String,text:String)
    {
        if kisiler.text!.characters.count >= 4
        {
        isim.removeAll()
        kulAdi.removeAll()
        kulEposta.removeAll()
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
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    if let jsonDic = json
                    {
                        for i in 0..<jsonDic.count
                        {
                            
                            if let jsonVeri = jsonDic[i] as? NSDictionary
                            {
                                if let isimler = jsonVeri[""] as? String
                                {
                                    let kAdim = jsonVeri[""] as? String
                                    
                                    let string = self.degisken
                                    if string.range(of:"\(kAdim!)") != nil {
                                        
                                    }
                                    else{
                                    
                                        self.isim.append(isimler)
                                      
                                        
                                        DispatchQueue.main.async {
                                            self.pckerView.reloadAllComponents()
                                          
                                            self.alertSwift.frame.size.height = self.frame.height-self.pckerView.frame.size.height
                                                  self.alertSwift.frame.size.height = self.frame.height+105
                                               
                                            
                                        }
                                    }
                                    
                                }
                                if let kAdi = jsonVeri[""] as? String
                                {
                                   self.kulAdi.append(kAdi)
                                    
                                }
                                if let Keposta = jsonVeri[""] as? String
                                {
                                    self.kulEposta.append(Keposta)
                                    
                                  
                                }
                                
                                
                            }
                            
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
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if degisken==kisiler.text && kisiler.text != "" && sil == 1
        {
            if string.characters.count == 0 && range.length > 0 {
                
                deger = kisiler.text!
                
                let result = String(deger.characters.dropLast(kAdiCount[kAdiCount.count-1]))
                
                kisiler.text=result
                kAdiCount.remove(at: kAdiCount.count-1)
                deger = kisiler.text!
                degisken=deger
                deger2 = degisken
                
                return false
            }
            
        }
        else{
            return true
        }
        return true
       
    }
  
    
    @IBAction func changed(_ sender: Any) {
        if listeAd.text!.count >= 3 {
         btnCreate.isEnabled=true
         }
        else{
            btnCreate.isEnabled=false
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == listeAd {
            sil = 0
        }
        else if textField == kisiler
        {
            sil = 1
        }
        if btnCreate.titleLabel?.text == "DÜZENLE"
        {
            btnCreate.isEnabled=true
        }
    }
    func delegate()
    {
        self.listeAd.delegate=self
        self.kisiler.delegate=self
        self.alertSwift.delegate=self as? SwiftAlertViewDelegate
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        listeAd.resignFirstResponder()
        kisiler.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
   
    
    
    
}
