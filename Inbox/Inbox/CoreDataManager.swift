import CoreData

let DEFAULT_CONTEXT = CoreDataManager.coreDataManagerSharedInstance.managedObjectContext

let BACKGROUND_CONTEXT = CoreDataManager.coreDataManagerSharedInstance.managedObjectContext

class CoreDataManager: NSObject
{
    static let coreDataManagerSharedInstance = CoreDataManager.init();
    
    override init()
    {
        super.init()
    }

    lazy var applicationDocumentsDirectory: URL =
    {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = Bundle.main.url(forResource:"Inbox", withExtension:"momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator =
    {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
    
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }
        catch let error as NSError
        {
            var dict = [String: AnyObject]()
        
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
        
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
        
            dict[NSUnderlyingErrorKey] = error
        
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)

            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
        }
        catch
        {
        
        }
    
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext =
    {
        let coordinator = self.persistentStoreCoordinator
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    func saveContext ()
    {
        if managedObjectContext.hasChanges
        {
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                let nserror = error as NSError
                
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                
                abort()
            }
        }
    }
}
