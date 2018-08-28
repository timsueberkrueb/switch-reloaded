import QtQuick 2.0
import QtQuick.Controls 2.0
import "../logic"

Item {
    id: matrixRow

    property var rowModel: []
    property bool isSelected: false
    property bool isRowCanonicalForm: {
        var canonical = false;
        for (var i=0; i<rowModel.length-1; i++) {
            if (rowModel[i] === 1 || rowModel[i] === -1) {
                if (canonical) {
                    canonical = false;
                    break;
                }
                canonical = true;
            }
            else if (rowModel[i] !== 0) {
                canonical = false;
                break;
            }
        }
        return canonical;
    }
    property color themeColor
    property color glowColor
    property bool active: true

    signal selected()

    implicitHeight: 48
    implicitWidth: content.width

    Item {
        id: content

        property alias rowModel: matrixRow.rowModel
        property bool hoveringDropArea: false

        height: 32
        width: row.childrenRect.width

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                when: dragArea.drag.active
                AnchorChanges {
                    target: content;
                    anchors.verticalCenter: undefined
                    anchors.left: undefined
                }
                ParentChange {
                    target: content
                    parent: matrixContainer
                }
            }
        ]

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: width/2
        Drag.hotSpot.y: height/2

        Row {
            id: row
            anchors.fill: parent
            spacing: 8

            Repeater {
                model: matrixRow.rowModel
                delegate: MatrixElement {
                    text: matrixRow.rowModel[index]
                    background: active
                    highlight:  index === matrixRow.rowModel.length-1
                    highlightColor: Qt.darker(themeColor, 1.5)
                    glowing: dropArea.containsDrag || isSelected
                    glowColor: matrixRow.glowColor
                }
            }
        }

        Rectangle {
            anchors {
                right: parent.left
                rightMargin: 16
                verticalCenter: parent.verticalCenter
            }

            implicitHeight: 32
            implicitWidth: 32

            opacity: content.hoveringDropArea ? 1 : 0
            color: themeColor
            radius: width * 0.5

            Label {
                anchors.centerIn: parent
                color: "white"
                text: "+"
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Rectangle {
            id: divideHelper
            anchors {
                left: parent.right
                leftMargin: 16
                verticalCenter: parent.verticalCenter
            }

            property int gcd: Matrix.gcdOfArray(rowModel)
            property bool relevant: Math.abs(gcd) > 1 || gcd === -1

            implicitHeight: 32
            implicitWidth: 32

            opacity: (relevant && !dragArea.drag.active && active) ? 1 : 0
            visible: opacity > 0
            color: themeColor
            radius: width * 0.5

            Label {
                anchors.centerIn: parent
                text: "÷" + divideHelper.gcd
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rowModel = Matrix.multiplyRow(rowModel, 1/divideHelper.gcd);
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: content
        drag.smoothed: true
        drag.threshold: 0
        drag.axis: Drag.YAxis

        onReleased: {
            content.Drag.drop()
        }

        onPressed: {
            matrixRow.selected();
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent

        onEntered: {
            drag.source.hoveringDropArea = drag.source !== content;
            drag.accept(Qt.CopyAction);
        }

        onExited: {
            drag.source.hoveringDropArea = false;
        }

        onDropped: {
            drag.source.hoveringDropArea = false;
            if (drop.source != content) {
                rowModel = Matrix.addRowToRow(drop.source.rowModel, rowModel);
            }
        }
    }
}
