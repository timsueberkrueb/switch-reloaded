import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."

Item {
    id: icon
    property string name: ""
    property real size: 24
    property color color: "white"
    property url source: name ? Qt.resolvedUrl("/icons/%1.svg".arg(name)): undefined

    implicitWidth: size
    implicitHeight: size

    Image {
        id: image
        anchors.fill: parent
        source: icon.source
        visible: true
        cache: true
        sourceSize {
            width: icon.size
            height: icon.size
        }
    }

    ColorOverlay {
        anchors.fill: image
        source: image
        color: Utils.alpha(icon.color, 1)
        cached: true
        visible: icon.source !== ""
        opacity: icon.color.a
    }
}
