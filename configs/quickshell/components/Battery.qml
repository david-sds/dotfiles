import QtQuick
import Quickshell.Services.UPower
import ".."

Rectangle {
    id: root
    property int percentage: UPower.displayDevice ? Math.round(UPower.displayDevice.percentage * 100) : 0
    property var defaultIcons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    property var chargingIcons: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
    property int iconIndex: Math.min(Math.floor(percentage / 10), 9)
    property bool charging: UPower.displayDevice && UPower.displayDevice.state === UPowerDeviceState.Charging
    property bool plugged: UPower.displayDevice && UPower.displayDevice.state === UPowerDeviceState.FullyCharged
    property string icon: plugged ? "" : (charging ? chargingIcons[iconIndex] : defaultIcons[iconIndex])

    width: batteryText.implicitWidth
    height: 22
    radius: 4

    color: Globals.backgroundColor

    Text {
        id: batteryText
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.foregroundColor
        text: root.icon + ' ' + root.percentage + '%'
    }
}
