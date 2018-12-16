import Foundation
import Capacitor
import CoreLocation
import os.log

@objc(GeofenceTracker)
public class GeofenceTracker: CAPPlugin {
   
    let locationManager = CLLocationManager()
    
    @objc func registerLocation(_ call: CAPPluginCall) {
        
        guard   
            let id = call.getString("id"),
            let latitude = call.getDouble("latitude"),
            let longitude = call.getDouble("longitude"),
            let radius = call.getDouble("radius")
            else {
                call.error("id, latitude, logitude and radius must not be nil")
                return
        }
        
        locationManager.requestAlwaysAuthorization();
        
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            radius: radius,
            identifier: id)
        region.notifyOnEntry = true
        region.notifyOnExit = true

        locationManager.startMonitoring(for: region)
        os_log("het werkt!")
        
        call.success()
    }
    
    @objc func unregisterLocation(_ call: CAPPluginCall) {
        guard
            let id = call.getString("id")
            else {
                call.error("id must not be nil")
                return
        }
        // TODO
        call.success()
    }
    
    @objc func getTrackedPresences(_ call: CAPPluginCall) {
        
        NSLog("Getting tracked presences")
        
        call.success(["presences": [
            "location": [
                "id": "somewhere",
                "latitude": 300.23,
                "longitude": 400.23,
                "radius": 2000.1,
            ],
            "start": "1976-07-13T23:05:01Z",
            "end": "2100-07-13T23:05:01Z"
        ]])
    }
    
    @objc func echo(_ call: CAPPluginCall) {
        print("echo!");
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
}
