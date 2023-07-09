//
//  MapView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-20.
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @EnvironmentObject private var mapViewModel: MapScreenViewModel
    
    @State private var selectedAQIData: AQIData?
    @State private var showingInfoSheet: Bool = false
    
    private var selectedSourceId: String?
    
    init(selectedSourceId: String? = nil) {
        self.selectedSourceId = selectedSourceId
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(
                coordinateRegion: $mapViewModel.region,
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: appViewModel.aqiData
            ) { item in
                MapAnnotation(coordinate: item.coordinates) {
                    AQIAnnotationView(aqiData: item,
                                      isSelected: .constant(item.source == mapViewModel.selectedSource))
                    .onTapGesture {
                        withAnimation {
                            mapViewModel.selectedSource = item.source
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
            HStack {
                Spacer()
                ZoomControls(plusButtonCallback: {
                    withAnimation {
                        mapViewModel.zoomIn()
                    }
                }, minusButtonCallback: {
                    withAnimation {
                        mapViewModel.zoomOut()
                    }
                })
                .background(CustomColors.viewBackgroundColor)
                .cornerRadius(8)
            }
            .padding()
            
            VStack {
                Spacer()
                if let aqiDataForSensorInfo = selectedAQIData {
                    SensorInfo(title: aqiDataForSensorInfo.description,
                               subtitle: nil,
                               aqiIndex: aqiDataForSensorInfo.quality.index,
                               favorited: Binding<Bool>(get: {
                         selectedAQIData?.isFavoriteSensor ?? false
                    }, set: { newValue in
                        if let copy = selectedAQIData?.copy(isFavoriteSensor: newValue) {
                            appViewModel.update(newValue: copy)
                            selectedAQIData = copy
                        }
                    }))
                    .frame(maxWidth: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(CustomColors.viewBackgroundColor)
                            .animation(nil, value: UUID())
                    )
                    .padding()
                    .transition(.move(edge: .bottom))
//                    .onChange(of: selectedAQIData?.isFavoriteSensor) { _ in
//                        guard let selectedAQIData else {
//                            return
//                        }
//
//                        appViewModel.update(newValue: selectedAQIData)
//                    }
                }
            }
        }
        .onChange(of: mapViewModel.selectedSource) { _ in
            showSelectedSource()
        }
        .onChange(of: appViewModel.aqiData) { _ in
            showSelectedSource(centerToSource: false)
        }
        .onChange(of: selectedSourceId) { newValue in
            mapViewModel.selectedSource = newValue
        }
        .onAppear {
            mapViewModel.selectedSource = self.selectedSourceId
        }
        .onDisappear {
            mapViewModel.selectedSource = nil
        }
        .sheet(isPresented: $showingInfoSheet, content: {
            InfoScreen()
                .frame(maxWidth: 720)
        })
        .toolbar {
            ToolbarItem {
                Button {
                    showingInfoSheet.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
                .disabled(appViewModel.isLoading)
            }
            
            ToolbarItem {
                Button {
                    mapViewModel.centerToUserLocation()
                } label: {
                    Image(systemName: "location")
                }
            }
            
            ToolbarItem {
                Button {
                    appViewModel.loadAQI()
                } label: {
                    if appViewModel.isLoading {
                        ProgressView()
                            .tint(Color.accentColor)
                            #if os(macOS)
                            .controlSize(.small)
                            #endif
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    private func showSelectedSource(centerToSource: Bool = true) {
        var targetAQIData: AQIData?
        
        if let selectedSource = mapViewModel.selectedSource {
            targetAQIData = appViewModel.aqiData(withSource: selectedSource)
        }
        
        withAnimation {
            selectedAQIData = targetAQIData
            
            if let selectedAQIData, centerToSource {
                mapViewModel.region.center = selectedAQIData.coordinates
            }
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
            .environmentObject(
                AppViewModel(repository: Samples.successfulAireLibreRepository)
            )
    }
}
