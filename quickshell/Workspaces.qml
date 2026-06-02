import QtQuick
import Quickshell.Hyprland

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

            color: isActive ? "#ffffff" : "#000000"

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + (parent.index + 1) + '" })')
            }

            Text {
                anchors.centerIn: parent
                text: (parent.index + 1) % 10
                color: parent.isActive ? "#000000" : (parent.ws ? "#ffffff" : "#686868")
            }
        }
    }
}
