import Foundation
import Capacitor
import CoreLocation
import os.log

@objc(GeofenceTracker)
public class GeofenceTracker: CAPPlugin, CLLocationManagerDelegate {
   
    let presencesKey = "presences";
    let locationManager = CLLocationManager()
    let iso8601 = ISO8601DateFormatter()
    
    deinit {
        os_log("deinit!");
    }
    
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
        
        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();
        
        os_log("%s", id);
        os_log("lat %d", latitude);
        os_log("long %d", longitude);
        os_log("radius %d", radius);
        
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude),
            radius: radius,
            identifier: id)
        region.notifyOnEntry = true
        region.notifyOnExit = true

        locationManager.startMonitoring(for: region)
        
        call.success()
    }
    
    @objc func getTrackedPresences(_ call: CAPPluginCall) {
        os_log("return values!");
       
        var result: [[String: String]] = [];
        let presences = getPresences();
        for presencesForRegion in presences.values {
            result.append(contentsOf: presencesForRegion)
        }
        
        call.success(["presences": result])
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("did enter!");
        if let region = region as? CLCircularRegion {
            var presences = getPresences(forRegion: region);
            let newPresence = ["id": region.identifier, "start": now()];
            presences.append(newPresence);
            setPresences(presences, forRegion: region);
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        os_log("did exit!");
        if let region = region as? CLCircularRegion {
            var presences = getPresences(forRegion: region);
            if var lastPresence = presences.last, lastPresence["end"] == nil {
                lastPresence["end"] = now();
                presences[presences.count - 1] = lastPresence;
                os_log("x");
            } else {
                let newPresence = ["id": region.identifier, "end": now()];
                presences.append(newPresence);
            }
            setPresences(presences, forRegion: region);
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        os_log("monitoring failed!");
    }
    
    
    @objc func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        os_log("did start monitoring!");
    }

    @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        os_log("did change authorization!");
    }
    
    private func getPresences(forRegion region: CLRegion) -> [[String: String]] {
        return getPresences()[region.identifier] ?? [];
    }
    
    private func setPresences(_ presences: [[String: String]], forRegion region: CLRegion) {
        let defaults = UserDefaults.standard
        var allPresences = getPresences();
        allPresences[region.identifier] = presences;
        defaults.set(allPresences, forKey: presencesKey);
    }
    
    private func getPresences() -> [String: [[String: String]]] {
        let defaults = UserDefaults.standard
        let presences = (defaults.dictionary(forKey: presencesKey) ?? [:]) as! [String: [[String: String]]];
        return presences;
    }
    
    private func now() -> String {
        return iso8601.string(from: Date())
    }
}

//struct [String: String] {
//    var id: String
//    var start: String?
//    var end: String?
//}
