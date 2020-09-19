//
//  ViewController.swift
//  getHeart
//
//  Created by terada enishi on 2020/09/13.
//  Copyright © 2020 terada enishi. All rights reserved.
//

import UIKit
import HealthKit
import WatchConnectivity

class ViewController: UIViewController {
    
       var startWatch:Bool?
    // HealthKitで扱うデータを管理するクラス(データの読み書きにはユーザの許可が必要)
       let healthStore = HKHealthStore()
       // 取得したいデータの識別子、今回は心拍数
       let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
       // 取得したデータの単位、今回はBPM
       let heartRateUnit = HKUnit(from: "count/min")
       // HealthStoreへのクエリ
       var heartRateQuery: HKQuery?
    @IBOutlet weak var showLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
          
               if self.heartRateQuery == nil {
                   // start
                   // クエリ生成
                   self.heartRateQuery = self.createStreamingQuery()
                   // クエリ実行
                   self.healthStore.execute(self.heartRateQuery!)
                   
                   
               }
               else {
                   // end
                   self.healthStore.stop(self.heartRateQuery!)
                   self.heartRateQuery = nil
                   
                   
               }
    }
    
   
    
    private func createStreamingQuery() -> HKQuery {
           let predicate = HKQuery.predicateForSamples(withStart: NSDate() as Date, end: nil)

           // HKAnchoredObjectQueryだと他のアプリケーションによる更新を検知することができる
           let query = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, samples, deletedObjects, anchor, error) -> Void in
               self.addSamples(samples: samples)
           }
           // Handler登録、上でやってるからいらないかも...
           query.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
               self.addSamples(samples: samples)
           }

           return query
       }
    // 取得したデータをLabelに表示
       private func addSamples(samples: [HKSample]?) {
           guard let samples = samples as? [HKQuantitySample] else {
               return
           }
           guard let quantity = samples.last?.quantity else {
               return
           }
        self.showLabel.text = ("\(quantity.doubleValue(for: heartRateUnit))")
       }
    
}

