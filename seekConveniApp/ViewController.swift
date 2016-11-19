//
//  ViewController.swift
//  seekConveniApp
//
//  Created by 高橋知憲 on 2016/11/20.
//  Copyright © 2016年 高橋知憲. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation


// CLLocationManagerDelegateを継承しなければならない
class ViewController: UIViewController,CLLocationManagerDelegate {
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // フィールドの初期化
        
        //現在地
        lm = CLLocationManager()
        //軽度
        longitude = CLLocationDegrees()
        //緯度
        latitude = CLLocationDegrees()
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示．必須．
        lm.requestAlwaysAuthorization()
        // 位置情報の精度を指定．任意，
        lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
        lm.distanceFilter = 10
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /* 位置情報取得成功時に実行される関数 */
    private func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        // 取得した緯度がnewLocation.coordinate.longitudeに格納されている
        latitude = newLocation.coordinate.latitude
        // 取得した経度がnewLocation.coordinate.longitudeに格納されている
        longitude = newLocation.coordinate.longitude
        // 取得した緯度・経度をLogに表示
        NSLog("latiitude: \(latitude) , longitude: \(longitude)")
        
        // GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．
        // lm.stopUpdatingLocation()
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ．
        NSLog("Error")
    }
}

