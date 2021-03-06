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
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print(beacons)
        if beacons .isEmpty {
            
        } else {
            self.beacons.append(beacons[0])
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
    @State var scanning = false
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
                    self.scanning ? self.sot.stopRangeBeacons() : self.sot.rangeBeacons()
                    self.scanning.toggle()
                }){
                    self.scanning ? Text("Stop Range Beacons") : Text("Start Range Beacons")
                        .fontWeight(.bold)
                }
                .frame(width: UIScreen.main.bounds.size.width - 100, height: 50)
                .background(self.scanning ? Color.orange : Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
                Spacer().frame(height: 10)
            }
            .navigationBarTitle(Text("iBeacon Scanner"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.sot.stopRangeBeacons()
                self.sot.beacons.removeAll()
            }){
                Text("Clear")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
