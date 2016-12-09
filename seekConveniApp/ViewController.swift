import UIKit
import MapKit
import CoreLocation

// CLLocationManagerDelegateを継承しなければならない
class ViewController: UIViewController, UISearchBarDelegate,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var conveniMapView: MKMapView! = MKMapView() //マップ生成
    @IBOutlet weak var destSearchBar: UISearchBar! //検索バー
    
    @IBOutlet weak var trackingButton: UIBarButtonItem! // トラッキングのボタン
    
    // 現在地の位置情報の取得にはCLLocationManagerを使用
    var lm: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // フィールドの初期化
        lm = CLLocationManager()
        
        conveniMapView.frame = self.view.frame
        
        
        //デリゲート先に自分を設定する。
        conveniMapView.delegate = self
        
        // CLLocationManagerをDelegateに指定
        lm.delegate = self
        
        // 位置情報取得の許可を求めるメッセージの表示．必須．
        lm.requestWhenInUseAuthorization()
        // 位置情報の精度を指定．任意，
        lm.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定．指定した値（メートル）移動したら位置情報を更新する．任意．
        lm.distanceFilter = 1000
        
        
        // GPSの使用を開始する
        lm.startUpdatingLocation()
        
        
        //現在位置の地図の表示
        // 距離のフィルタ.
        lm.distanceFilter = 100.0
        
        //スケールを表示する
        conveniMapView.showsScale = true
        
        // 長押しのUIGestureRecognizerを生成.
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(ViewController.recognizeLongPress(sender:)))
        
        // MapViewにUIGestureRecognizerを追加.
        conveniMapView.addGestureRecognizer(myLongPress)
        
    }
    
    /*
     長押しを感知した際に呼ばれるメソッド.
     */
    func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        // 長押しの最中に何度もピンを生成しないようにする.
        if sender.state != UIGestureRecognizerState.began {
            return
        }
        
        // 長押しした地点の座標を取得.
        let location = sender.location(in: conveniMapView)
        
        // locationをCLLocationCoordinate2Dに変換.
        let myCoordinate: CLLocationCoordinate2D = conveniMapView.convert(location, toCoordinateFrom: conveniMapView)
        
        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = myCoordinate
        
        // タイトルを設定.
        myPin.title = "タイトル"
        
        // サブタイトルを設定.
        myPin.subtitle = "サブタイトル"
        
        // MapViewにピンを追加.
        conveniMapView.addAnnotation(myPin)
    }
    
    /*
     addAnnotationした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        
        // アニメーションをつける.
        myPinView.animatesDrop = true
        
        // コールアウトを表示する.
        myPinView.canShowCallout = true
        
        // annotationを設定.
        myPinView.annotation = annotation
        
        return myPinView
        
    }
    
    
    //トラッキングボタンが押されたときのメソッド（トラッキングモード切り替え）
    @IBAction func tapTrackingButton(_ sender: UIBarButtonItem) {
        switch conveniMapView.userTrackingMode{
        case .none:
            //noneからfollowへ
            conveniMapView.setUserTrackingMode(.follow, animated: true)
            //トラッキングボタンの画像を変更する
            trackingButton.image = UIImage(named: "trackingFollow")
            
        case .follow:
            //followからfollowWithHeadingへ
            conveniMapView.setUserTrackingMode(.followWithHeading, animated: true)
            //トラッキングボタンの画像を変更する
            trackingButton.image = UIImage(named: "trackingHeading")
            
        case .followWithHeading:
            //followWithHeadingからnoneへ
            conveniMapView.setUserTrackingMode(.none, animated: true)
            //トラッキングボタンの画像を変更する
            trackingButton.image = UIImage(named: "trackingNone")
        }
    }
    
    
    //トラッキングが自動解除された
    @objc(mapView:didChangeUserTrackingMode:animated:) func mapView (_ mapView :MKMapView, didChange mode:MKUserTrackingMode, animated:Bool){
        trackingButton.image = UIImage(named: "trackingNone")
    }
    
    //位置情報利用許可のステータスが変わった
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        //ロケーションの更新を開始する
        case .authorizedAlways, .authorizedWhenInUse:
            lm.startUpdatingLocation()
            
            //トラッキングボタンを有効にする
            trackingButton.isEnabled = true
            
        default:
            
            //ロケーションの更新を停止する
            lm.stopUpdatingLocation()
            
            //トラッキングモードをnoneにする
            conveniMapView.setUserTrackingMode(.none, animated: true)
            
            // トラッキングボタンを変更する
            trackingButton.image = UIImage(named: "trackingNone")
            
            //トラッキングボタンを無効にする
            trackingButton.isEnabled = false
        }
    }
}




