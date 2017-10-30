//
//  GorevEkle.swift
//  Ortaklist
//
//  Created by MacMini on 16.10.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class GorevEkle: UIView,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    let datePicker = UIDatePicker()
    var listeID=""
    var uyeId=""
    var gorevId=""
    var tip = ""
    var secilenuyeler=""
    var baslik = ""
    var detay = ""
    var baslangicZamanı = ""
    var sonZamani = ""
    var parameters=""
    var kontrol = 0
   
    @IBOutlet weak var baslıkLabel: UILabel!
    @IBOutlet weak var baslıkText: UITextField!
    @IBOutlet weak var detayText: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createBtn: UIButton!
    var selectedIndex : [IndexPath]! = [IndexPath]()
    var checked = [Bool]()

    var isim=[String]()
    var ePosta=[String]()
    var kAdi=[String]()
    var sIsim=[String]()
    var sEposta=[String]()
    var sKadi=[String]()
    var alertSwift:SwiftAlertView!
    func contentalertView(_ alert: SwiftAlertView)
    {
        self.alertSwift = alert
        
        
    }
    @IBAction func btnVazgec(_ sender: Any) {
        self.alertSwift.dismiss()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        baslıkText.resignFirstResponder()
        detayText.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    func calıstır()
    {
          gorevlendirelecekler(urlString: "http://ortaklist.com/webservices/ios/service_app_22042017/liste_detay.php")
        
    }
    func gorevDuzenleme()
    {
        gorevDuzenle(urlString: "http://ortaklist.com/webservices/ios/service_app_22042017/gorev_detay.php")
       
    }
    func gorevDuzenle(urlString:String)
    {

       
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        let parameters = "gorevid="+gorevId
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    if let gelenBaslik = json["baslik"] as? String
                    {
                        self.baslik=gelenBaslik
                        DispatchQueue.main.async {
                             self.baslıkText.text!=self.baslik
                        }
                       
                    }
                    if let gelenDetay = json["detay"] as? String
                    {
                        self.detay=gelenDetay
                           DispatchQueue.main.async {
                        self.detayText.text!=self.detay
                        }
                    }
                    if let gelenBasTarih = json["bastarih"] as? String
                    {
                        self.baslangicZamanı=gelenBasTarih
                           DispatchQueue.main.async {
                        self.startDate.text!=self.baslangicZamanı
                        }
                    }
                    if let gelenSonTarih = json["sontarih"] as? String
                    {
                        self.sonZamani=gelenSonTarih
                           DispatchQueue.main.async {
                        self.endDate.text=self.sonZamani
                        }
                    }
                    if let gelenlisteId = json["listeid"] as? String
                    {
                        self.listeID=gelenlisteId
                       
                        self.gorevlendirelecekler(urlString: "http://ortaklist.com/webservices/ios/service_app_22042017/liste_detay.php")
                    }
                  
                    if let jsonDic = json["secilmis_uyeler"] as! NSArray?
                    {
                        for i in 0..<jsonDic.count
                        {
                            if let jsonVeri = jsonDic[i] as? NSDictionary
                            {
                                if let gelenIsim = jsonVeri["isim"] as? String
                                {
                                    self.sIsim.append(gelenIsim)
                                    
                                }
                                if let gelenEposta = jsonVeri["eposta"] as? String
                                {
                                    self.sEposta.append(gelenEposta)
                                    
                                }
                                if let gelenKadi = jsonVeri["kullanici_adi"] as? String
                                {
                                    self.sKadi.append(gelenKadi)
                                    
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                }
                catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
 
    @IBAction func changed(_ sender: Any) {
        if createBtn.titleLabel?.text != "DÜZENLE"
        {
        if baslıkText.text!.count >= 3 {
            createBtn.isEnabled=true
        }
        else
        {
             createBtn.isEnabled=false
        }
        }
    }
    
    @IBAction func btnCreateAction(_ sender: Any) {
        if createBtn.titleLabel?.text == "DÜZENLE"
        {
           
            gorevOlustur(urlString: "http://ortaklist.com/webservices/ios/service_app_22042017/gorevi_duzenle.php")
           
        }
        else
        {
        gorevOlustur(urlString: "http://ortaklist.com/webservices/ios/service_app_22042017/yeni_gorev_ekle.php")
        }
        secilenuyeler=""
        self.alertSwift.dismiss()
    }
    func gorevOlustur(urlString:String)
    {
        
        let urlRequest = URL(string: urlString)
        var request = URLRequest(url: urlRequest! as URL)
        request.httpMethod = "POST"
        
        if createBtn.titleLabel?.text == "DÜZENLE"
        {
             parameters = "baslik="+baslıkText.text!+"&detay="+detayText.text!+"&secilenuyeler="+secilenuyeler+"&baslangic="+startDate.text!+"&sonbulma="+endDate.text!+"&gorevid="+gorevId+"&uyeid="+uyeId
           
        }
        else
        {
             parameters = "baslik="+baslıkText.text!+"&detay="+detayText.text!+"&baslangic="+startDate.text!+"&sonbulma="+endDate.text!+"&listeid="+listeID+"&uyeid="+uyeId+"&secilenuyeler="+secilenuyeler
        }
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil
            {
                print(error!)
            }
            else {
              print("başarılı")
                self.isim.removeAll()
                self.ePosta.removeAll()
                self.kAdi.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isim.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          cell.backgroundColor = UIColor.lightGray
          cell.selectionStyle=UITableViewCellSelectionStyle.none
          self.tableView.backgroundColor = UIColor.lightGray
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        if  selectedIndex.contains(indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
         
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
            
        
        }
        
        if createBtn.titleLabel?.text == "DÜZENLE"
        {
            if sKadi.contains(kAdi[indexPath.row]) {
                cell.accessoryType = .checkmark
                
                
                if secilenuyeler.range(of:ePosta[indexPath.row]+",") == nil {
                    secilenuyeler=secilenuyeler+ePosta[indexPath.row]+","
                }
                
             
                
            }
            
            
        }
      
        cell.textLabel?.text=isim[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        createBtn.isEnabled=true
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle=UITableViewCellSelectionStyle.none
        cell?.backgroundColor = UIColor.lightGray
     
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            if sKadi.contains(kAdi[indexPath.row]) {
                
                sKadi = sKadi.filter{$0 != kAdi[indexPath.row]}
                var kelime = secilenuyeler
                let kelimesil = ePosta[indexPath.row]+","
                if let range = kelime.range(of: kelimesil) {
                    kelime.removeSubrange(range)
                }
                secilenuyeler = kelime
                
            }
            self.selectedIndex = selectedIndex.filter({
                return $0 != indexPath
            })
            
            var kelime = secilenuyeler
            let kelimesil = ePosta[indexPath.row]+","
            if let range = kelime.range(of: kelimesil) {
                kelime.removeSubrange(range)
            }
            secilenuyeler = kelime
        }
        else
        {
          
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
             
           
            self.selectedIndex.append(indexPath)
          
        
            secilenuyeler = secilenuyeler+ePosta[indexPath.row]+","
            
        }
     
        
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

                    if let jsonDic = json[""] as! NSArray?
                    {
                        for i in 0..<jsonDic.count
                        {
                            if let jsonVeri = jsonDic[i] as? NSDictionary
                            {
                                if let gelenIsim = jsonVeri[""] as? String
                                {
                                    self.isim.append(gelenIsim)
                                    
                                }
                                if let gelenEposta = jsonVeri[""] as? String
                                {
                                    self.ePosta.append(gelenEposta)
                                    
                                }
                                if let gelenKadi = jsonVeri[""] as? String
                                {
                                    self.kAdi.append(gelenKadi)
                                    
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                }
                catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    @IBAction func startDateClick(_ sender: Any) {
        creatDatePicker()
       
        
    }
    @IBAction func endDateClick(_ sender: Any) {
        endDatePicker()
    }
    
    func creatDatePicker()
    {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        startDate.inputAccessoryView = toolbar
        startDate.inputView=datePicker
        
    }
    @objc func donePressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy 00:00"
        startDate.text = dateFormatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    func endDatePicker()
    {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed2))
        toolbar.setItems([doneButton], animated: true)
        endDate.inputAccessoryView = toolbar
        endDate.inputView=datePicker
    }
    @objc func donePressed2()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy 00:00"
        
        
        endDate.text = dateFormatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if createBtn.titleLabel?.text == "DÜZENLE"
        {
            createBtn.isEnabled=true
        }
    }
    
    
    
}
