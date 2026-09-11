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
                    width: 16
                    height: 16
                    source: trayIcon.item.icon
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if ((mouse.button === Qt.LeftButton || mouse.button === Qt.RightButton) && trayIcon.item.hasMenu) {
                            trayMenuLoader.active = false;
                            trayMenuLoader.pendingAnchor = trayIcon;
                            trayMenuLoader.pendingMenu = trayIcon.item.menu;
                            trayMenuLoader.active = true;
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: trayMenuLoader
        active: false
        property Item pendingAnchor: null
        property var pendingMenu: null
        sourceComponent: Component {
            TrayMenu {
                isRoot: true
            }
        }
        onLoaded: {
            item.anchorItem = trayMenuLoader.pendingAnchor;
            item.anchorRect = Qt.rect(0, trayMenuLoader.pendingAnchor.height, 1, 1);
            item.menuHandle = trayMenuLoader.pendingMenu;
            item.rootRef = item;
            item.closeRequested.connect(function () {
                trayMenuLoader.active = false;
            });
            item.visible = true;
        }
    }
}
