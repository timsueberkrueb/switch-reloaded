import QtQuick 2.0
import QtGraphicalEffects 1.0


Item {
    property alias text: t.text
    property bool highlight: false
    property bool glowing: false
    property color glowColor
    property color highlightColor
    property bool background: true

    implicitHeight: 32
    implicitWidth: 32

    RectangularGlow {
        id: effect
        anchors.fill: parent
        opacity: glowing ? 1 : 0
        glowRadius: 5
        spread: 0.2
        color: glowColor
        cornerRadius: rect.radius + glowRadius

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        visible: opacity > 0
        opacity: background ? 1 : 0
        radius: 5
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: highlight ? highlightColor : "#f2f2f2" }
            GradientStop { position: 1.0; color: highlight ? highlightColor : "#e6e6e6" }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    }

    Text {
        id: t
        color: highlight || !background ? "white" : "black"
        anchors.centerIn: rect
    }
}
