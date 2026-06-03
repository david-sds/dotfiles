import QtQuick
import Quickshell.Hyprland
import Quickshell.Io
import ".."

Rectangle {
    readonly property var layouts: ({
            "us intl": "INTL",
            "us": "EN",
            "br nodeadkeys": "PT-ND",
            "br": "PT"
        })
    property string icon: ""
    property string currentLayout

    width: kbText.implicitWidth
    height: 22
    radius: 4
    color: Globals.backgroundColor

    Process {
        id: kbProc
        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main) | \"\\((.layout / \",\")[.active_layout_index]) \\((.variant / \",\")[.active_layout_index])\"'"]
        running: true

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                currentLayout = layouts[text.trim()];
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout")
                kbProc.running = true;
        }
    }

    Process {
        id: keyboardProc
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: keyboardProc.exec(["sh", "-c", "hyprctl switchxkblayout all next"])
    }

    Text {
        id: kbText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.highlightColor
        text: parent.currentLayout + " " + parent.icon
    }
}
