import QtQuick 2.0
import "../controls"

Item {
    id: checkmarks

    property int max: 5
    property int current: 0
    property color color
    property int size: 16

    implicitHeight: size
    implicitWidth: row.childrenRect.width

    Row {
        id: row

        Repeater {
            model: 5

            Icon {
                property bool checked: index < current

                name: checked ? "checkbox-outline" : "checkbox-outline-blank"
                color: checkmarks.color
                size: checkmarks.size
            }
        }
    }
}
