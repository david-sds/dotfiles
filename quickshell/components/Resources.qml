import QtQuick
import Quickshell.Io
import ".."

Rectangle {
    width: resourcesText.implicitWidth
    height: 22
    radius: 4
    color: Globals.backgroundColor

    Process {
        id: resourcesProc
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: resourcesProc.exec(["sh", "-c", "$HOME/.local/bin/open-floating-tui btop"])
    }

    Text {
        id: resourcesText
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.highlightColor
        text: '󰍛'
    }
}
