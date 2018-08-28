import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

Rectangle {
    id: multiplySlider

    property color themeColor
    property int range: 15
    property int factor: {
        if (dragArea.drag.active) {
            var relLen = ((multiplySlider.width - 16) / 2) + (multiplySliderRect.width / 2)
            var relPos = dropArea.drag.x - relLen;
            var perc = (relPos / relLen);
            var value = Math.ceil(perc * (range + 1));
            return value === 0 ? 1 : value;
        }
        return 1;
    }

    signal multiply(int factor)

    color: Qt.darker(themeColor, 1.5)
    implicitHeight: 64

    Item {
        anchors {
            fill: parent
        }

        Label {
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 32
            }
            font.pixelSize: 16
            font.bold: true
            text: "-"
            color: "white"
        }

        Rectangle {
            id: multiplySliderRect
            anchors {
                bottom: parent.bottom
                margins: 24
            }

            x: parent.width/2 - width/2
            width: 32
            height: 32
            radius: width * 0.5
            color: "white"

            Drag.active: dragArea.drag.active
            Drag.hotSpot.x: width/2
            Drag.hotSpot.y: height/2

            states: [
                State {
                    when: !dragArea.drag.active
                    PropertyChanges {
                        target: multiplySliderRect
                        x: parent.width/2 - width/2
                    }
                }
            ]

            Label {
                anchors.centerIn: parent
                text: "×"
                font.pixelSize: 16
                font.bold: true
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.threshold: 0
                onReleased: {
                    multiply(factor);
                }
            }

            Item {
                opacity: dragArea.drag.active ? 1 : 0
                visible: matrixWidget.isRowSelected && opacity > 0
                z: 20

                anchors {
                    bottom: multiplySliderRect.top
                    horizontalCenter: multiplySliderRect.horizontalCenter
                }

                width: 38
                height: 48

                Canvas {
                    y: 12

                    width: parent.width
                    height: parent.width

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.fillStyle = themeColor;
                        ctx.beginPath();
                        ctx.moveTo(8, 0);

                        ctx.quadraticCurveTo(14, height, width/2, height);
                        ctx.quadraticCurveTo(width-14, height, width-8, 0);
                        ctx.closePath();
                        ctx.fill();
                    }
                }

                Rectangle {
                    width: parent.width
                    height: width
                    radius: width * 0.5
                    color: themeColor

                    Label {
                        anchors.centerIn: parent
                        text: "×%1".arg(multiplySlider.factor.toString())
                        color: "white"
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

        Label {
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 32
            }
            font.pixelSize: 16
            font.bold: true
            text: "+"
            color: "white"
        }

        DropArea {
            id: dropArea
            anchors.fill: parent
        }
    }
}
