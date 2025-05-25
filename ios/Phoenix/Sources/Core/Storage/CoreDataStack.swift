import CoreData
import Foundation

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Phoenix")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
    
    private init() {}
}

// MARK: - Core Data Operations

extension CoreDataStack {
    
    // MARK: - Check-ins
    
    func saveCheckIn(moodLevel: Int, urgeLevel: Int, triggerContext: String, note: String) {
        let checkIn = CheckInEntity(context: context)
        checkIn.id = UUID()
        checkIn.moodLevel = Int16(moodLevel)
        checkIn.urgeLevel = Int16(urgeLevel)
        checkIn.triggerContext = triggerContext
        checkIn.note = note
        checkIn.createdAt = Date()
        checkIn.isSynced = false
        
        save()
    }
    
    func fetchCheckIns() -> [CheckInEntity] {
        let request: NSFetchRequest<CheckInEntity> = CheckInEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CheckInEntity.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func getUnsyncedCheckIns() -> [CheckInEntity] {
        let request: NSFetchRequest<CheckInEntity> = CheckInEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isSynced == NO")
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Tips
    
    func saveTip(id: UUID, title: String, content: String, category: String, isBookmarked: Bool = false) {
        let tip = TipEntity(context: context)
        tip.id = id
        tip.title = title
        tip.content = content
        tip.category = category
        tip.isBookmarked = isBookmarked
        tip.createdAt = Date()
        
        save()
    }
    
    func fetchTips(category: String? = nil) -> [TipEntity] {
        let request: NSFetchRequest<TipEntity> = TipEntity.fetchRequest()
        
        if let category = category {
            request.predicate = NSPredicate(format: "category == %@", category)
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TipEntity.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func toggleTipBookmark(tip: TipEntity) {
        tip.isBookmarked.toggle()
        save()
    }
    
    // MARK: - Quiz Data
    
    func saveQuizResult(domain: String, score: Int, totalQuestions: Int) {
        let result = QuizResultEntity(context: context)
        result.id = UUID()
        result.domain = domain
        result.score = Int16(score)
        result.totalQuestions = Int16(totalQuestions)
        result.completedAt = Date()
        
        save()
    }
    
    func fetchQuizResults() -> [QuizResultEntity] {
        let request: NSFetchRequest<QuizResultEntity> = QuizResultEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \QuizResultEntity.completedAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Dashboard Data
    
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let checkIns = fetchCheckIns()
        var streak = 0
        var currentDate = today
        
        for checkIn in checkIns {
            guard let checkInDate = checkIn.createdAt else { continue }
            let checkInDay = calendar.startOfDay(for: checkInDate)
            
            if calendar.isDate(checkInDay, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getUrgeFreeDays() -> Int {
        let calendar = Calendar.current
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        
        let request: NSFetchRequest<CheckInEntity> = CheckInEntity.fetchRequest()
        request.predicate = NSPredicate(format: "createdAt >= %@ AND urgeLevel <= 3", thirtyDaysAgo as NSDate)
        
        do {
            return try context.count(for: request)
        } catch {
            return 0
        }
    }
} 