pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Widgets
import ".."

PopupWindow {
    id: level
    property QsMenuHandle menuHandle: null
    property Item anchorItem
    property var anchorRect: Qt.rect(0, 0, 1, 1)
    property int anchorEdges: Edges.Bottom | Edges.Left
    property int anchorGravity: Edges.Bottom | Edges.Right
    property bool isRoot: false
    property int expandedIndex: -1
    property TrayMenu rootRef: null

    signal closeRequested

    function closeAll() {
        rootRef.closeRequested();
    }

    visible: false
    grabFocus: true
    implicitWidth: 200
    implicitHeight: levelCol.implicitHeight + 8
    color: "transparent"

    anchor.item: anchorItem
    anchor.rect: anchorRect
    anchor.edges: anchorEdges
    anchor.gravity: anchorGravity
    anchor.adjustment: PopupAdjustment.FlipX | PopupAdjustment.SlideY

    Timer {
        id: collapseTimer
        interval: 250
        onTriggered: level.expandedIndex = -1
    }

    onClosed: {
        visible = false;
        if (isRoot)
            closeAll();
    }

    QsMenuOpener {
        id: opener
        menu: level.menuHandle
    }

    Rectangle {
        anchors.fill: parent
        color: Globals.backgroundColor
        border.color: Globals.borderColor
        radius: 4

        Column {
            id: levelCol
            anchors.fill: parent
            anchors.margins: 4

            Repeater {
                id: menuRepeater
                model: opener.children.values
                delegate: Item {
                    id: rowItem
                    required property int index
                    required property QsMenuEntry modelData

                    readonly property bool hasSubmenu: modelData.hasChildren

                    width: levelCol.width
                    height: modelData.isSeparator ? 5 : 22

                    Rectangle {
                        visible: rowItem.modelData.isSeparator
                        width: parent.width
                        height: 1
                        anchors.verticalCenter: parent.verticalCenter
                        color: Globals.borderColor
                    }

                    Rectangle {
                        visible: !rowItem.modelData.isSeparator
                        anchors.fill: parent
                        radius: 2
                        color: (rowMa.containsMouse || (level.expandedIndex === rowItem.index && !collapseTimer.running)) ? Globals.borderColor : "transparent"

                        IconImage {
                            id: icon
                            visible: rowItem.modelData.icon !== ""
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 6
                            implicitSize: 14
                            asynchronous: true
                            source: rowItem.modelData.icon
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: icon.visible ? icon.right : parent.left
                            anchors.leftMargin: 6
                            font.family: Globals.fontFamily
                            font.pixelSize: Globals.fontPixelSize
                            text: rowItem.modelData.text
                            color: rowItem.modelData.enabled ? Globals.foregroundColor : Globals.disabledColor
                        }

                        Text {
                            visible: rowItem.hasSubmenu
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            font.family: "Symbols Nerd Font"
                            font.pixelSize: 12
                            text: ""
                            color: rowItem.modelData.enabled ? Globals.foregroundColor : Globals.disabledColor
                        }

                        Loader {
                            id: submenuLoader
                            active: level.expandedIndex === rowItem.index
                            source: "TrayMenu.qml"
                            onLoaded: {
                                item.menuHandle = rowItem.modelData;
                                item.anchorItem = rowItem;
                                item.anchorRect = Qt.rect(4, 0, rowItem.width - 8, 1);
                                item.anchorEdges = Edges.Right | Edges.Top;
                                item.anchorGravity = Edges.Right | Edges.Bottom;
                                item.rootRef = level.rootRef;
                                item.visible = true;
                            }
                        }

                        Timer {
                            id: expandTimer
                            interval: 200
                            onTriggered: level.expandedIndex = rowItem.index
                        }

                        MouseArea {
                            id: rowMa
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: rowItem.modelData.enabled
                            onEntered: {
                                if (rowItem.hasSubmenu)
                                    expandTimer.restart();
                                if (level.expandedIndex !== -1 && level.expandedIndex !== rowItem.index)
                                    collapseTimer.restart();
                                else
                                    collapseTimer.stop();
                            }
                            onExited: expandTimer.stop()
                            onClicked: {
                                if (!rowItem.hasSubmenu) {
                                    rowItem.modelData.triggered();
                                    level.closeAll();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
