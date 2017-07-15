import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Item {
    id: tutorialSection

    property Item content

    Flickable {
        anchors {
            fill: parent
        }

        contentHeight: contentContainer.height
        clip: true

        ScrollBar.vertical: ScrollBar { active: true }

        Item {
            id: contentContainer
            y: 16
            x: 16
            width: parent.width - 32
            height: content.childrenRect.height + 32
            children: content
        }
    }
}
