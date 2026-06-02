import QtQuick
import Quickshell.Io
import ".."

Rectangle {
    width: 22
    height: 22
    radius: 4

    color: mouseArea.containsMouse ? Globals.highlightColor : Globals.backgroundColor

    Process {
        id: powerProc
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: powerProc.exec(["sh", "-c", "$HOME/.local/bin/walker-powermenu"])
    }

    Text {
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: mouseArea.containsMouse ? Globals.backgroundColor : Globals.highlightColor
        text: ''
    }
}
