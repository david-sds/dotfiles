pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import ".."

Rectangle {
    id: root
    property QtObject parentWindow: null
    property var systemTrayItems: SystemTray.items
    property string icon: ""

    height: 22
    width: trayText.implicitWidth
    radius: 4
    color: Globals.backgroundColor

    Row {
        id: trayText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        // Text {
        //     font.family: Globals.fontFamily
        //     font.pixelSize: Globals.fontPixelSize
        //     color: Globals.foregroundColor
        //     text: icon
        // }

        Repeater {
            model: root.systemTrayItems.values
            Rectangle {
                id: trayIcon
                width: 16
                height: 16
                color: Globals.backgroundColor
                required property int index
                property SystemTrayItem item: root.systemTrayItems.values[index]
                Image {
                    anchors.centerIn: parent
                    width: 14
                    height: 14
                    source: trayIcon.item.icon
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton && trayIcon.item.hasMenu) {
                            var pos = mouseArea.mapToItem(null, mouse.x, mouse.y);
                            trayIcon.item.display(root.parentWindow, pos.x, pos.y);
                        }
                    }
                }
            }
        }
    }
}
