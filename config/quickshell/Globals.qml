pragma Singleton
import QtQuick

QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font Propo"
    readonly property int fontPixelSize: 12

    readonly property string background: '#141617'
    readonly property string foreground: '#ebdbb2'
    readonly property string red: '#fb4934'
    readonly property string orange: '#fe8019'
    readonly property string yellow: '#fabd2f'
    readonly property string green: '#b8bb26'
    readonly property string aqua: '#8ec07c'
    readonly property string blue: '#83a598'
    readonly property string purple: '#d3869b'
    readonly property string grey: '#7c6f64'

    readonly property string backgroundColor: background
    readonly property string foregroundColor: foreground
    readonly property string primaryColor: red
    readonly property string secondaryColor: green
    readonly property string borderColor: grey
    readonly property string disabledColor: '#555555'
}
