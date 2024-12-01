// src/main/kotlin/how/virc/flutter_esp_ble_prov/WifiNetwork.kt

package how.virc.flutter_esp_ble_prov

import java.io.Serializable

/**
 * Data class representing a Wi-Fi network with SSID and RSSI.
 */
data class WifiNetwork(
    val ssid: String,
    val rssi: Int
) : Serializable
