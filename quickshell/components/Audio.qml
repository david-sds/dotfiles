import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."

Rectangle {
    property string formatMutedIcon: ""
    property string headphoneIcon: ""
    property var defaultIcons: ["", "", ""]
    property int volume: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
    property bool muted: Pipewire.defaultAudioSink.audio.muted ?? false
    property int iconIndex: Math.min(Math.floor(volume / 33), 2)
    property string defaultSinkPort: ""
    property bool isHeadphones: defaultSinkPort.toLowerCase().includes("headphone") || defaultSinkPort.toLowerCase().includes("headset")
    property string icon: muted ? formatMutedIcon : (isHeadphones ? headphoneIcon : defaultIcons[iconIndex])

    width: 22
    height: 22
    radius: 4
    color: Globals.backgroundColor

    function refreshDefaultSinkPort() {
        portProc.exec(["sh", "-c", "def=\"$(pactl get-default-sink)\"; pactl list sinks | awk -v def=\"$def\" '$1==\"Name:\" {found=($2==def)} found && $1==\"Active\" && $2==\"Port:\" {print $3; exit}'"]);
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Process {
        id: popupProc
    }

    Process {
        id: portProc

        stdout: SplitParser {
            onRead: data => {
                defaultSinkPort = data.trim();
            }
        }
    }

    Process {
        id: pulseEvents
        command: ["pactl", "subscribe"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                line = line.trim();
                if (line.match(/ on (sink|server|card) /))
                    refreshDefaultSinkPort();
            }
        }

        onRunningChanged: {
            if (!running)
                running = true;
        }
    }

    Component.onCompleted: refreshDefaultSinkPort()

    Process {
        id: audioProc
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: audioProc.exec(["sh", "-c", "$HOME/.local/bin/open-floating-tui wiremix"])
    }

    Text {
        anchors.centerIn: parent
        font.family: Globals.fontFamily
        font.pixelSize: Globals.fontPixelSize
        color: Globals.highlightColor
        text: icon + ' ' + volume + '%'
    }
}
