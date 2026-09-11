import Quickshell
import QtQuick
import "components"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            required property var modelData
            screen: modelData

            color: Globals.backgroundColor

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

            Workspaces {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
            }

            Text {
                font.family: Globals.fontFamily
                font.pixelSize: Globals.fontPixelSize
                anchors.centerIn: parent
                text: Time.time
                color: Globals.foregroundColor
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                spacing: 16

                Tray {
                    parentWindow: panelWindow
                }
                Keyboard {}
                Bluetooth {}
                Network {}
                Resources {}
                Audio {}
                Battery {}
                Power {}
            }
        }
    }
}
