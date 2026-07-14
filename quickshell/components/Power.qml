import QtQuick
import Quickshell.Io
import ".."

Rectangle {
    width: powerText.implicitWidth
    height: 22
    radius: 4

    color: Globals.backgroundColor

    Process {
        id: powerProc
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: powerProc.exec(["sh", "-c", "walker-powermenu"])
    }

    Text {
        id: powerText
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: mouseArea.containsMouse ? Globals.primaryColor : Globals.foregroundColor
        text: ''
    }
}
