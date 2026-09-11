import QtQuick
import Quickshell.Hyprland
import ".."

Row {
    id: root

    spacing: 4

    Repeater {
        model: 10

        Rectangle {
            required property int index
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === index + 1

            width: 22
            height: 22
            radius: 4

            color: /*isActive ? Globals.foregroundColor : */ Globals.backgroundColor

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
                onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + (parent.index + 1) + '" })')
            }

            Text {
                font.family: Globals.fontFamily
                font.pixelSize: Globals.fontPixelSize
                anchors.centerIn: parent
                text: (parent.index + 1) % 10
                color: mouseArea.containsMouse || parent.isActive ? Globals.primaryColor : (parent.ws ? Globals.secondaryColor : Globals.grey)
            }
        }
    }
}
