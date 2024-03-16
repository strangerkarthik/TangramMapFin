//
//  ViewController.swift
//  TangramMap VM
//
//  Created by Karthikraja on 16/03/24.
//

import UIKit
import TangramMap



class ViewController: UIViewController, TGMapViewDelegate, TGRecognizerDelegate {
    
    var mapView: TGMapView!
    var markers: [TGMarker] = []
    var polylines: [TGGeoPolyline] = []
    var polygons: [TGGeoPolygon] = []
    var polylinePoints: [CLLocationCoordinate2D] = []
    var polygonPoints: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
           super.viewDidLoad()


        let containerView = UIView()
           containerView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(containerView)


        NSLayoutConstraint.activate([
               containerView.topAnchor.constraint(equalTo: view.topAnchor),
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])


        mapView = TGMapView(frame: CGRect.zero)
           mapView.mapViewDelegate = self
           mapView.gestureDelegate = self
           mapView.translatesAutoresizingMaskIntoConstraints = false
        
           containerView.addSubview(mapView)

        
        
           let stackView = UIStackView()
           stackView.axis = .vertical
           stackView.alignment = .fill
           stackView.spacing = 10
           stackView.translatesAutoresizingMaskIntoConstraints = false
           containerView.addSubview(stackView)


        NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
               stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
               stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
           ])


        addButtonsToStackView(stackView)


        NSLayoutConstraint.activate([
               mapView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
               mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
               mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
               mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
           ])
       }

       func addButtonsToStackView(_ stackView: UIStackView) {
           
           let addMarkerButton = UIButton(type: .system)
           addMarkerButton.setTitle("Add Marker", for: .normal)
           addMarkerButton.addTarget(self, action: #selector(addMarker), for: .touchUpInside)
           stackView.addArrangedSubview(addMarkerButton)


           let removeMarkerButton = UIButton(type: .system)
           removeMarkerButton.setTitle("Remove Marker", for: .normal)
           removeMarkerButton.addTarget(self, action: #selector(removeMarker), for: .touchUpInside)
           stackView.addArrangedSubview(removeMarkerButton)

           let drawPolylineButton = UIButton(type: .system)
           drawPolylineButton.setTitle("Draw Polyline", for: .normal)
           drawPolylineButton.addTarget(self, action: #selector(startDrawingPolyline), for: .touchUpInside)
           stackView.addArrangedSubview(drawPolylineButton)


           let drawPolygonButton = UIButton(type: .system)
           drawPolygonButton.setTitle("Draw Polygon", for: .normal)
           drawPolygonButton.addTarget(self, action: #selector(startDrawingPolygon), for: .touchUpInside)
           stackView.addArrangedSubview(drawPolygonButton)
       }

    
    @objc func addMarker() {
        
        let latitude = Double.random(in: -90...90)
        let longitude = Double.random(in: -180...180)
        
        let marker = mapView.markerAdd()
        marker.stylingString = "{ style: 'points', color: 'white', size: [25px, 25px], order:500 }"
        marker.point = CLLocationCoordinate2D(latitude: 40.70532700869127, longitude: -74.00976419448854)
        marker.icon = UIImage(named: "map")!
        
        markers.append(marker)
    }
    
    @objc func removeMarker() {

        if let marker = markers.popLast() {
            mapView.markerRemove(marker)
        }
    }
    
    @objc func startDrawingPolyline() {
        addPolyline()
    }
    
    func addPolyline() {
  
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 40.70532700869127, longitude: -74.00976419448854),
            CLLocationCoordinate2D(latitude: 40.712776, longitude: -74.006009),
            CLLocationCoordinate2D(latitude: 40.730975, longitude: -73.992493)
        ]

        
        let polyline = TGGeoPolyline(coordinates: coordinates, count: 3)
        let b = mapView.markerAdd()
        b.stylingString = "{ style: 'lines', color: 'blue', width: 5, order: 500, cap: 'round', join: 'round' }";
        b.polyline = polyline
    
        markers.append(b)
    }
    
    @objc func startDrawingPolygon() {

        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 40.70532700869127, longitude: -74.00976419448854),
            CLLocationCoordinate2D(latitude: 50.712776, longitude: -94.006009),
            CLLocationCoordinate2D(latitude: 20.730975, longitude: -83.992493)
        ]

        let coordinates2: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 41.70532700869127, longitude: -75.00976419448854),
            CLLocationCoordinate2D(latitude: 100.712776, longitude: -99.006009),
            CLLocationCoordinate2D(latitude: 31.730975, longitude: -22.992493)
        ]
        let polyline1 = TGGeoPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let polyline2 = TGGeoPolyline(coordinates: coordinates2, count: UInt(coordinates2.count))
        let polygon = TGGeoPolygon(rings: [polyline1, polyline2])

        let marker = mapView.markerAdd()
        marker.polygon = polygon

        marker.stylingString = "{ style: 'polygons', color: 'blue', width: 5, order: 500, cap: 'round', join: 'round' }"

        markers.append(marker)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let apiKey = "cwhNz_x7SwS1feeAaVQN_w"
        let sceneUpdates = [TGSceneUpdate(path: "global.sdk_api_key", value: apiKey)]
        let sceneUrl = URL(string: "https://www.nextzen.org/carto/bubble-wrap-style/9/bubble-wrap-style.zip")!
        mapView.loadSceneAsync(from: sceneUrl, with: sceneUpdates)
    }
    
    func mapView(_ mapView: TGMapView, didLoadScene sceneID: Int32, withError sceneError: Error?) {
        if let error = sceneError {
            print("Scene load error: \(error.localizedDescription)")
        } else {
            print("Scene loaded successfully.")
           
            let Newyork = CLLocationCoordinate2D(latitude: 40.70532700869127, longitude: -74.00976419448854)
            mapView.cameraPosition = TGCameraPosition(center: Newyork, zoom: 10, bearing: 0, pitch: 0)
        }
    }
    
    func mapView(_ view: TGMapView!, recognizer: UIGestureRecognizer!, didRecognizeSingleTapGesture location: CGPoint) {
        let coordinate = view.coordinate(fromViewPosition: location)
        print("Tapped location: \(coordinate.longitude), \(coordinate.latitude)")
    }
}
