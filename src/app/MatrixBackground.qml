import QtQuick 2.0

Rectangle {
    color: "black"

    property color characterColor: "green"

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

            // Width change: recalculate columns
            if (canvas.width !== previousWidth) {
                // Columns (depending on canvas width)
                var columns = Math.floor(canvas.width/fontSize);

                // Array of drops
                for (var x=0; x<columns; x++) { // x: coordinate
                    drops[x] = 1;               // y: 1 initially
                }

                // Set width
                previousWidth = canvas.width;
            }

            // Background with 0.05 transparency for the trail
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.05);
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Character style
            ctx.fillStyle = characterColor;
            ctx.font = fontSize.toString() + "px sans-serif";

            // Draw characters
            for (var i=0; i < drops.length; i++) {
                var character = characters[Math.floor(Math.random()*characters.length)];
                ctx.fillText(character, i*fontSize, drops[i]*fontSize);

                // Back to top randomly
                if (drops[i]*fontSize > canvas.height && Math.random() > 0.975) {
                    drops[i] = 0;
                }

                drops[i]++;
            }
        }

        Timer {
            interval: 30
            repeat: true
            running: true
            onTriggered: if (visible) canvas.requestPaint();
        }
    }
}

