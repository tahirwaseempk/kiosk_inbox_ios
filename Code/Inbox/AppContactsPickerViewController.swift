import UIKit

class AppContactsPickerViewController: UIViewController,SwiftMultiSelectDelegate,SwiftMultiSelectDataSource
{
    var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var initialValues:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var selectedItems:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //createItems()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        createItems()
    }
    
    func createItems()
    {
        Config.doneString = "Ok"
        SwiftMultiSelect.dataSource     = self
        SwiftMultiSelect.delegate       = self
        
        self.items.removeAll()
        self.initialValues.removeAll()
        
        for i in 0..<50
        {
            items.append(SwiftMultiSelectItem(row: i, title: "test\(i)", description: "description for: \(i)", imageURL : (i == 1 ? "https://randomuser.me/api/portraits/women/68.jpg" : nil)))
        }
        
        self.initialValues = [self.items.first!,self.items[1],self.items[2]]
        
        //self.selectedItems = items
        
        SwiftMultiSelect.initialSelected = []
        
        let selector = MultiSelecetionViewController()
        
        // Set initial items
        //selector.selectedItems  = self.selectedItems
        
        //Create navigation controller
        
        // Present selectora
        
        self.present(selector, animated: true, completion: nil)

        //SwiftMultiSelect.Show(to: self)
    }
    
    func userDidSearch(searchString: String)
    {
        if searchString == ""
        {
            selectedItems = items
        }
        else
        {
            selectedItems = items.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })
        }
    }
    
    func numberOfItemsInSwiftMultiSelect() -> Int
    {
        return selectedItems.count
    }
    
    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem)
    {
        print("row: \(item.title) has been deselected!")
    }
    
    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem)
    {
        print("item: \(item.title) has been selected!")
    }
    
    func didCloseSwiftMultiSelect()
    {
        
    }
    
    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem
    {
        return selectedItems[row]
    }
    
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem])
    {
        initialValues   = items
        
        print("you have been selected: \(items.count) items!")
        
        for item in items
        {
            print(item.string)
        }
    }
}
