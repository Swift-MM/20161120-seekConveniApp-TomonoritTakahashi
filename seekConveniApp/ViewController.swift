import UIKit
import MapKit
import CoreLocation

// CLLocationManagerDelegateを継承しなければならない
class ViewController: UIViewController, UISearchBarDelegate,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var testManager:CLLocationManager = CLLocationManager()
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    // 取得した緯度を保持するインスタンス
    var latitude: CLLocationDegrees!
    // 取得した経度を保持するインスタンス
    var longitude: CLLocationDegrees!
    

    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // フィールドの初期化
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        
        //中心座標
        let center = CLLocationCoordinate2DMake(35.0, 140.0)
        
        //表示範囲
        let span = MKCoordinateSpanMake(1.0, 1.0)
        
        //中心座標と表示範囲をマップに登録する。
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated:true)
        
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
        
        
        
        //デリゲート先を自分に設定する。
        searchBar.delegate = self
    }
    
    
    
    //検索ボタン押下時の呼び出しメソッド
    func searchButtonClicked(searchBar: UISearchBar) {
        
        //キーボードを閉じる。
        searchBar.resignFirstResponder()
        
        //検索条件を作成する。
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        
        //検索範囲はマップビューと同じにする。
        request.region = mapView.region
        
        //ローカル検索を実行する。
        let localSearch:MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: {(result, error) in
            
            for placemark in (result?.mapItems)! {
                if(error == nil) {
                    
                    //検索された場所にピンを刺す。
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                    annotation.title = placemark.placemark.name
                    annotation.subtitle = placemark.placemark.title
                    self.mapView.addAnnotation(annotation)
                    
                } else {
                    //エラー
                    print(error)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //ここはOKそう
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        // 取得した緯度がnewLocation.coordinate.longitudeに格納されている
        latitude = newLocation!.coordinate.latitude
        // 取得した経度がnewLocation.coordinate.longitudeに格納されている
        longitude = newLocation!.coordinate.longitude
    
        // 取得した緯度・経度をLogに表示
        NSLog("latitude: \(latitude) , longitude: \(longitude)")
        // GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．
        // lm.stopUpdatingLocation()
    }





    /* 位置情報取得失敗時に実行される関数 */
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    // この例ではLogにErrorと表示するだけ．
    NSLog("Error")
    }

}
