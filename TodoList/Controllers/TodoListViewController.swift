

import UIKit
// bu satırı eklemeyi unutma
import CoreData

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
  
    
    // aşağıdaki satırla UIApplication sınıfına giriyoruz. shared singleton objesini alıyoruz. persistentContainer giriyoruz ve viewContext i yakalıyoruz.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
// aşağıdaki kodlara artık lüzum görmüyoruz. loadItems() metoduyla verileri plistten decode edip  array türüne dönüştüreceğiz
    override func viewDidLoad() {
     super.viewDidLoad()

    
        // database dosyamızın hangi dosyada saklı olduğunu öğrenmek için yazıyoruz bu kodu
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
        // herhangi bir satıra basıldığında satırın silinmesini istiyorsak sıralamanın aşağıdaki gibi olması gerekiyor. aksi takdirde hata veriyor. ilk başta context den sonra itemArraydan silinmesi gerekiyor. aksi takdirde itemAray objesi kullanıldığı için index hatası veriyor.
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
      
       // reload metodu saveItems() metodunda kullanıldığı için tekrardan yazmaya gerek yok.
        // yaptığımız değişikliklerden sonra veriyi permenant yapmak için bu metodu kullanmamız gerekiyor. 
        
        saveItems()
      
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Yeni Bir Yapılacak Ekle", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yeni Ekle", style: .default) { (action) in
        
            
            
            
            // butona basar basmaz bir Item objesi oluşturuluyor. Bu Item objesi CoreModel attribute ları oluşturulurken otomatik oluşturulmuştu. Bu sınıflar localde library de görüntülenebilir. videolarda mevcut
            let newItem = Item(context: self.context)
            // şimdi her bir attribute a ulaşabiliyoruz ve bunları dolduruyoruz.
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            // bu attribute lar doldurulduktan sonra kalıcı olarak saklamak için save ediyoruz. aşağıdaki metodun içeriğine bak
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
    
    
   
    func saveItems() {
       
        do {
            // CRUD işlemlerinden sonra verilerden memnun isek save() metodu ile verileri persistent/Permanent yapıyoruz
           try context.save()
        }catch{
            print("Error Saving Context \(error)")
        }
        // bu satır olmadan table a yansımıyor yani görünmüyor. append yaptıktan sonra mutlaka table view e reload yapmak gereklidir.
        // crud yapıldıktan sonra da bu metodun çağrılması gerekiyor ki table tekrardan yüklensin
        self.tableView.reloadData()
        
    }
    // burada yukarıdakine farklı olarak verileri plist ten array a "decode" ediyoruz. yani her iki durumda da bir dönüşüm söz konusu...
    
    // request internal item. with request internal item.
    // loadItems() ile parametresiz çağrıldığında default olarak eşitliğin sağ tarafındaki kısım icra edilir yani request değişkenine atanır. loadItems(with: request) parametre ile çağrıldığında eşitliğin sol yanı icra ediliyor yani bir nevi sağ taraf yok sayılıyor.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        // context fetch request yapıyor.
        do{
        itemArray = try context.fetch(request)
        } catch {
            print("error by the time of fetching \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Metodları
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // contexten bilgi almak için fetch request yapıyoruz.
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Aşağıdaki nasıl sorgu yapılacağını belirtiyor.
        // Database den title attribute a bakılacak. %@(searchBar.text!) argümanının içerecek(CONTAINS). [cd] komutu case insensitive yapıyor aramayı. [cd] komutunu yerleştirmeksek case sensitive olacak.
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
       
        
        // Aşağıdaki satır database den aldığımız satırın nasıl sıralanacağını belirtiyor.
        // Belirtildiği gibi alfabetik sıraya göre sıralama yapacak.
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // request i parametre olarak gönderiyoruz. tableReload u aşağıya yazmamıza gerek yok.
        loadItems(with: request)
   
        
    }
    
}

