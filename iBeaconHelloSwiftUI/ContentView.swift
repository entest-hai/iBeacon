//
//  ContentView.swift
//  iBeaconHelloSwiftUI
//
//  Created by hai on 17/3/21.
//  Copyright © 2021 biorithm. All rights reserved.
//

import SwiftUI
import CoreLocation

class MyLocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var beacons = [CLBeacon]()
    let locationManager = CLLocationManager()
    let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "DD880E2B-DC11-4D4B-9B50-96DB60B2C151")!)
    override init() {
        super.init()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        print("initialised a LocationManager")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        if beacons .isEmpty {
            
        } else {
            self.beacons.append(beacons[0])
            print(self.beacons.count)
        }
    }
    
    func rangeBeacons(){
        locationManager.startRangingBeacons(satisfying: constraint)
    }
    
    func stopRangeBeacons(){
        locationManager.stopRangingBeacons(satisfying: constraint)
    }
}

struct ContentView: View {
    @ObservedObject var sot = MyLocationManager()
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ForEach(self.sot.beacons.reversed(), id: \.self){beacon in
                        Text("\(beacon) ")
                    }
                }
                
                Spacer()
                
                Button(action: {
                    self.sot.rangeBeacons()
                }){
                    Text("Start Range Beacons")
                        .fontWeight(.bold)
                }
                .frame(width: UIScreen.main.bounds.size.width - 100, height: 50)
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                Spacer().frame(height: 10)
                
                Button(action: {
                    self.sot.stopRangeBeacons()
                }){
                    Text("Stop Range Beacons")
                        .fontWeight(.bold)
                }
                .frame(width: UIScreen.main.bounds.size.width - 100, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                Spacer().frame(height: 10)
            }
        .navigationBarTitle(Text("iBeacon Scanner"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
