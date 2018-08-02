//
//  ViewController.swift
//  TodoList
//
//  Created by Demo on 30.07.2018.
//  Copyright © 2018 RN. All rights reserved.
//

import UIKit

// main story de default gelen UIView i sildik. yerine sağ alttan tableViewController sürükledik. şimdi bunu bu sınıf ile bağlamak için UIViewController(default) sınıfını silip yerine "UITableViewController" ekliyoruz. sonra da sağ taraftan
// "ViewController" yazan dosyanın ismini "TodoListViewController" koyuyoruz(keyfi). sonrasıda aşağıdaki class ismini de anyı isimle değiştiriyoruz. En sonda da inspector kısmından class ismini değiştiriyoruz.
// neden delegate ve datasource u burada belirtmedik? Single subclassing diyor cevabı ama araştır.
class TodoListViewController: UITableViewController {
    

    // let kelimesi immutable dır. Bunun yerine mutable olan var kodunu kullanıp aşağıda append yapabileceğiz.
    
    var itemArray = [Item]()
    
    // kalıcı olarak verileri saklamak için bir saklama biçimi herhalde. plist dosyasında saklanır. çağrıldığında hepsini getirir. özellikle default muzik sesi vs. küçük durumlar için kullanılır. arraylist vs. için kullanılmaz genelde. custom datatype için genelde UserDefaults kullanılmaz. UserDefaults genelde standart veri tipleri için kullanılır.
    // Yukarıdaki açıklamalar aşağıda uncomment yapılan satır için geçerliydi
    // let defaults = UserDefaults.standard
    
    
    // filemanager ile data file path oluşturuyoruz. array olduğu için ilk elemanı istiyoruz. first den sonraki kısım Item adlı plist dosyası oluşturmamız içindir. Global constant olarak tanıtıyoruz.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
// aşağıdaki kodlara artık lüzum görmüyoruz. loadItems() metoduyla verileri plistten decode edip  array türüne dönüştüreceğiz
    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        let newItem = Item()
//        newItem.title = "Find Zeynel"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Find Asude"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Find Muhammed"
//        itemArray.append(newItem3)
    
        loadItems()
        
        // retrieve data from a registered plist(local de "self.defaults.set(self.itemArray, forKey: "TodoListArray")"
        // işleminden sonra plist dosyasına atılıyor veri) aşağıdaki işlem ile geri çekiyoruz. alınan veri bu sefer Item objesi...
        // Yukarıdaki yorum satırları aşağıdaki 2 uncomment olan kod satırı içindir.
        // if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        // itemArray = items
}
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        // indexPath yukarıdaki değişkendir.(current IndexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // ternary operator kullanıyoruz if else yerine. eğer item.done true ise "cell.accessoryType" değişkenini checkmark yap true değilse uncheck yap
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
        
        
    }
    
    //Mark - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // burada seçilen row un accessory kısmını checkmark yapıyoruz. eğer checkmark ise none ile uncheck yaptırıyoruz.
        // toggle ve untoggle yaptırıyoruz burada.
        // dikkat! operatörü aynen aşağıda kullanıldığı gibi kullan yoksa hata veriyor.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       // reload metodu saveItems() metodunda kullanıldığı için tekrardan yazmaya gerek yok.
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Yeni Bir Yapılacak Ekle", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yeni Ekle", style: .default) { (action) in
        
        // alert kısmından gelen ve global değişkene atanan değer array list e ekleniyor.
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            // yeni bir şey eklediğimizde plist e ekleneceği için aşağıdaki metodu çağırıyoruz.
            self.saveItems()
            
        }
        // alert i clouser ın dışına çıkarmak için global değişken ekliyoruz.(textField yukarıda tanımlandı). Burada alertTextField den gelen değer global değişkene aktarılıyor.
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Yeni Bir Yapılacak Ekle"
            textField = alertTextField
        }
        alert.addAction(action)
        // show alert
        present(alert, animated: true, completion: nil)
    }
    
    
    // done kısmının custom plist e kaydedilmesini de burada yapıyoruz. clouser olmadığı için self komutunu siliyoruz.
    // burada verileri arraydan plist dosyasına aktarırken "encode" yapıyoruz.
    func saveItems() {
        // verileri append ettikten sonra saklamayı sağlıyoruz. aşağıdaki satır User defaults ile ilgili olduğu için programın çökmesine neden oluyor. bunu uncomment yapıp custom veri tipi için aşağıdaki satırları yazıyoruz.
        // self.defaults.set(self.itemArray, forKey: "TodoListArray")
        let encoder = PropertyListEncoder()
        // encode edeceğimiz obje itemArray
        do {
            // ilk satırda encode ediyoruz array ı, ikinci satırda da path ile belirtilen dosyaya yazıyoruz.
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("error encoding item array, \(error)")
        }
        // bu satır olmadan table a yansımıyor yani görünmüyor. append yaptıktan sonra mutlaka table view e reload yapmak gereklidir.
        self.tableView.reloadData()
        
    }
    // burada yukarıdakine farklı olarak verileri plist ten array a "decode" ediyoruz. yani her iki durumda da bir dönüşüm söz konusu...
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            // plist ten decode yaparaken aşağıdaki yapıyı kullanıyoruz. ilk parametre type: Item
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("erorr by the time decoding \(error)")
            }
        }
        
    }
    
    
    
    

}

