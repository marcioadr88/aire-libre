//
//  MapView.swift
//  Aire Libre
//
//  Created by Marcio Duarte on 2023-01-20.
//

import SwiftUI
import MapKit
import WidgetKit

struct MapScreen: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @EnvironmentObject private var mapViewModel: MapScreenViewModel

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
                                      isSelected: .constant(item.source == mapViewModel.selectedData?.source))
                        .onTapGesture {
                            withAnimation {
                                mapViewModel.selectedData = item
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
                if let selectedData = mapViewModel.selectedData,
                    let selectedDataBinding = Binding<AQIData>($mapViewModel.selectedData) {
                    SensorInfo(title: selectedData.description,
                               subtitle: nil,
                               aqiIndex: selectedData.quality.index,
                               favorited: selectedDataBinding.isFavoriteSensor)
                    .frame(maxWidth: 500)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(CustomColors.viewBackgroundColor)
                            .animation(nil, value: UUID())
                    )
                    .padding()
                    .transition(.move(edge: .bottom))
                    .onChange(of: selectedDataBinding.isFavoriteSensor.wrappedValue) { newValue in
                        //update view model with the updated selectedData values
                        guard let updatedSelectedData = self.mapViewModel.selectedData else {
                            return
                        }

                        appViewModel.update(newValue: updatedSelectedData)
                    }
                }
            }
        }
        .onChange(of: selectedSourceId) { selectedSourceId in
            if let selectedSourceId {
                showSelectedSource(selectedSourceId)
            }
        }
        .onChange(of: appViewModel.aqiData, perform: { _ in
            // update current selected sensor info with new updated data
            if let target = selectedSourceId ?? mapViewModel.selectedData?.source {
                withAnimation {
                    showSelectedSource(target, centerToSource: false)
                }
            }
        })
        .onAppear {
            if let selectedSourceId {
                showSelectedSource(selectedSourceId)
            }
        }
        .toolbar {
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
                    WidgetCenter.shared.reloadAllTimelines()
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
    
    private func showSelectedSource(_ source: String,
                                    centerToSource: Bool = true) {
        let targetData = appViewModel
            .aqiData
            .first(where: { $0.source == source })
        
        withAnimation {
            mapViewModel.selectedData = targetData
            
            if let targetData, centerToSource {
                mapViewModel.region.center = targetData.coordinates
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
