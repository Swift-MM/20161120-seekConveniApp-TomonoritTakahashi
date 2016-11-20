import UIKit
import MapKit
import CoreLocation

// CLLocationManagerDelegateを継承しなければならない
class ViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView! = MKMapView()
    @IBOutlet weak var destSearchBar: UISearchBar!
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // フィールドの初期化
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        //デリゲート先に自分を設定する。
        mapView.delegate = self
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示．必須．
        lm.requestAlwaysAuthorization()
        // 位置情報の精度を指定．任意，
        // lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
        // lm.distanceFilter = 1000
        
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
        
        
        //現在位置の地図の表示
        // 距離のフィルタ.
        lm.distanceFilter = 100.0
        
    }
    
    //ここはOKそう
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        // 取得した緯度がnewLocation.coordinate.longitudeに格納されている
        latitude = newLocation!.coordinate.latitude
        // 取得した経度がnewLocation.coordinate.longitudeに格納されている
        longitude = newLocation!.coordinate.longitude
        
        //現在位置をマップの中心にして登録する。
        for location in locations {
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(center, span)
            mapView.setRegion(region, animated:true)
        }
        
        // 取得した緯度・経度をLogに表示
        NSLog("latitude: \(latitude) , longitude: \(longitude)")
        // GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．
        // lm.stopUpdatingLocation()
    }
    
    /* 位置情報取得失敗時に実行される関数 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // この例ではLogにErrorと表示するだけ．
        NSLog("Error")
    }
    
//    @IBAction func pressMap(_ sender: UILongPressGestureRecognizer) {
//        //マップビュー内のタップした位置を取得する。
//        let location:CGPoint = sender.location(in: mapView)
//        
//        if (sender.state == UIGestureRecognizerState.ended){
//            
//            //タップした位置を緯度、経度の座標に変換する。
//            let mapPoint:CLLocationCoordinate2D = mapView.converttoCoordinateFromPoint(location, toCoordinateFromView: mapView)
//            
//            //ピンを作成してマップビューに登録する。
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
//            annotation.title = "目的地候補"
//            annotation.subtitle = "ボタンタップで経路を表示"
//            mapView.addAnnotation(annotation)
//            
//        }
//    }
    
    
}
