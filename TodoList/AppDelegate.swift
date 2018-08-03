// kopyalayıp yapıştırdığımız kısımlara iyi bak. CoreDataTest projesinin AppDelegate dosyasından core data ile ilgili metodları buraya yapıştırdık. import CoreData yazmasan hata veriyor.
// container parametresine atanan satırdaki String in oluşturduğumuz data modelinin ismini alması çok önemli(Şu an DataModel)
// DataModel dosyası oluşturulup Item.Swift e göre configüre edildikten sonre Item.Swift dosyasını sildik. 
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

  
    func applicationWillTerminate(_ application: UIApplication) {
      
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy  ile tanımlanan bir değişken sadece lazım olduğu an yükleniyor.
    // hafızayı bu şekilde verimli kullanabiliyoruz.
    // NSPersistentContainer da bütün verilerimizi saklıyoruz. SQL database ine benzer.
    // Hata yoksa container objesini dönecek.
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    // Uygulama sonlandığında bu metod verilerimizi saklar.
    func saveContext () {
        // context github daki stage area kısmına benziyor. sürekli verilerimizi değiştirip bizi mutlu edene kadar bu değişkeni update ediyoruz.
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                // Bizi mutlu eden durumu yukarıdaki permenant data olan "persistentContainer" da saklıyoruz.
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

