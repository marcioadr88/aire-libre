# Aire Libre for iOS, iPadOS, macOS and watchOS

[Spanish](README.es.md)

The purpose of this application is to allow users to view nearby and available sensors and Air Quality Index (AQI) readings obtained through the [Aire Libre](https://github.com/melizeche/AireLibre) project API, hence its name. More information about the project can be found at [www.airelib.re](www.airelib.re).

All data consumed and displayed in the application are obtained from the endpoint provided by the project mentioned above.

## Screenshots

### Apps

| ![iOS](readme_files/ss_iphone.png)  **iOS** | ![iPadOS](readme_files/ss_ipad.png) **iPadOS** |
| :---: | :--: |
| ![macOS](readme_files/ss_mac.png) **macOS** | ![watchOS](readme_files/ss_watch.png)  **watchOS** |

### Widgets
| ![iOS/iPadOS Home Screen](readme_files/widget_home_screen.png)  **iOS/iPadOS Home Screen**  | ![iOS Lock Screen](readme_files/widget_lock_screen.png)  **iOS Lock Screen** |
| :---: | :--: |
| ![watchOS](readme_files/widget_watchos.png)  **watchOS** | ![macOS medium](readme_files/widget_macos.png)  **macOS** |

## Technologies and Frameworks used
The project utilizes SwiftUI as the user interface framework across all platforms and widgets. This provides the advantage of sharing common code between different project targets.

It is important to note that no third-party libraries are used in the development. This decision has the benefit of avoiding the need to include dependency managers such as Swift PM, Cocoapods, among others.

## Project Organization
Below is a diagram that illustrates the file structure of the project.

![](readme_files/project_structure.png)

Here is a diagram showcasing the components and dependencies of the project.

![](readme_files/dependency_diagram.png)

`Shared App UI` contains common code used by the applications. This code includes Views, ViewModels, navigation, utilities, and extensions. It is important to mention that the architecture used for the applications is MVVM.

`Shared Widget UI` encompasses the common code necessary for the widgets to function. This includes views for different widget sizes, Entries, and Configurations.

Both the applications and widgets depend on a set of common code that provides the foundation for their functionality. This code is located in the `Common` folder and includes the following:

* **Localization**: Classes and resources used to access localized strings.
* **Stores**: Used to access local persistence, with an implementation that utilizes CoreData.
* **Models**: Common models used throughout the project.
* **Services**
    * **Networking**: Abstractions and classes for accessing the network and obtaining data from the web service.
    * **Persistence**: Abstractions and implementations for persistence services.
* **Colors**: Global colors used throughout the project.
* **AQIGauge**: A widely-used Gauge view in the project.
* **Utils**, **Extensions**: Miscellaneous utilities and extensions.

## Working with the Project
To open the project, clone the repository and open the `Aire Libre.xcodeproj` file.

You can report bugs and submit PRs if you wish to contribute to the project. Suggestions and feedback are welcome.

## License
GNU General Public License