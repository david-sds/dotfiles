import QtQuick
import Quickshell.Io
import Quickshell.Bluetooth
import ".."

Rectangle {
    property string bluetoothOnIcon: ""
    property string bluetoothOffIcon: "󰂲"
    property bool isBluetoothOn: Bluetooth.defaultAdapter?.enabled ?? false
    property string icon: isBluetoothOn ? bluetoothOnIcon : bluetoothOffIcon

    width: 22
    height: 22
    radius: 4
    color: Globals.backgroundColor

    Process {
        id: bluetoothProc
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: bluetoothProc.exec(["sh", "-c", "$HOME/.local/bin/open-floating-tui bluetui"])
    }

    Text {
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.highlightColor
        text: parent.icon
    }
}
