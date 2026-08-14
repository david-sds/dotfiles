pragma ComponentBehavior: Bound
import ".."
import QtQuick
import Quickshell

Rectangle {
    id: root
    width: resourcesText.implicitWidth
    height: 22
    radius: 4
    color: Globals.backgroundColor

    ListModel {
        id: menuModel
        ListElement {
            text: "Open"
            isSeparator: false
            enabled: true
        }
        ListElement {
            text: "Settings"
            isSeparator: false
            enabled: true
        }
        ListElement {
            text: ""
            isSeparator: true
            enabled: true
        }
        ListElement {
            text: "Quit"
            isSeparator: false
            enabled: false
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: menuPopup.visible = !menuPopup.visible
    }

    Text {
        id: resourcesText
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: mouseArea.containsMouse ? Globals.primaryColor : Globals.foregroundColor
        text: 'TESTE'
    }

    PopupWindow {
        id: menuPopup
        visible: false
        grabFocus: true
        implicitWidth: 140
        implicitHeight: col.implicitHeight + 8
        color: "transparent"

        anchor.item: root
        anchor.rect: Qt.rect(0, root.height, 1, 1)

        onClosed: visible = false

        Rectangle {
            anchors.fill: parent
            color: "#141617"
            border.color: "#7c6f64"
            radius: 4

            Column {
                id: col
                anchors.fill: parent
                anchors.margins: 4

                Repeater {
                    model: menuModel
                    delegate: Item {
                        id: item
                        required property string text
                        required property bool isSeparator

                        width: col.width
                        height: isSeparator ? 5 : 22

                        Rectangle {
                            visible: item.isSeparator
                            width: parent.width
                            height: 1
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#7c6f64"
                        }

                        Rectangle {
                            visible: !item.isSeparator
                            anchors.fill: parent
                            radius: 2
                            color: ma.containsMouse ? "#7c6f64" : "transparent"

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 6
                                text: item.text
                                color: parent.parent.enabled ? "#ebdbb2" : "#555"
                            }

                            MouseArea {
                                id: ma
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: parent.parent.enabled
                                onClicked: {
                                    console.log("triggered:", item.text);
                                    menuPopup.visible = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
