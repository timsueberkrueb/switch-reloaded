import QtQuick 2.0

Item {
    id: iconButton

    property alias iconName: icon.name
    property alias iconSource: icon.source
    property alias iconColor: icon.color
    property alias iconSize: icon.size

    signal clicked()

    implicitHeight: 24
    implicitWidth: 24

    Icon {
        id: icon
        anchors.centerIn: parent
        size: 24
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            iconButton.clicked();
        }
    }
}
