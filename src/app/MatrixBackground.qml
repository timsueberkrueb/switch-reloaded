import QtQuick 2.0

Rectangle {
    color: "black"

    property color characterColor: "green";
    property color foregroundColor: "white";

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(characterColor.r, characterColor.g, characterColor.b, 0.3);

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        property int previousWidth: 0
        property var characters: [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        ]
        property int fontSize: 10
        property var drops: []

        onPaint: {
            var ctx = canvas.getContext("2d");

            // Background with 0.05 transparency for the trail
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0);
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Character style
            ctx.fillStyle = foregroundColor;
            ctx.font = fontSize.toString() + "px monospace";

            var columns = Math.floor(canvas.width/fontSize);
            var rows = Math.floor(canvas.height/fontSize);

            // Draw characters
            for (var i=0; i < columns; i++) {
                var current_row = Math.floor(Math.random()*rows);
                for (var j=0; j < 10; j++) {
                    var r = Math.max(0, current_row - 10 + j);
                    ctx.fillStyle = Qt.rgba(foregroundColor.r, foregroundColor.g, foregroundColor.b, j/10);
                    var character = characters[Math.floor(Math.random()*characters.length)];
                    ctx.fillText(character, i*fontSize, r*fontSize);
                }
            }
        }
    }
}

