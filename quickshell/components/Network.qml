import QtQuick
import Quickshell.Io
import Quickshell.Networking
import ".."

Rectangle {
    property string disconnectedIcon: "󰤮"
    property string ethernetIcon: "󰀂"
    property var defaultIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired)
    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property bool wiredConnected: wiredDevice?.connected ?? false
    property bool wifiConnected: wifiDevice?.connected ?? false
    readonly property var wifiNetwork: (wifiDevice?.networks?.values ?? []).find(net => net.connected)
    readonly property real signalStrength: Math.round((wifiNetwork.signalStrength ?? 0) * 100)
    property int iconIndex: Math.min(Math.floor(signalStrength / 20), 4)
    property string icon: wiredConnected ? ethernetIcon : (wifiConnected ? defaultIcons[iconIndex] : disconnectedIcon)

    width: networkText.implictWidth
    height: 22
    radius: 4
    color: Globals.backgroundColor

    Process {
        id: networkProc
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: networkProc.exec(["sh", "-c", "$HOME/.local/bin/open-floating-tui impala"])
    }

    Text {
        id: networkText
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.highlightColor
        text: parent.icon
    }
}
