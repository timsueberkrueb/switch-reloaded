import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import "../controls"

Page {
    id: tutorialPage

    property color linkColor: "#388E3C"
    property color quoteColor: "#757575"

    signal popRequested()

    function quote(text, author) {
        return "“%1” - <i>%2</i>".arg(text).arg(author);
    }

    title: qsTr("Tutorial")
    visible: false

    onVisibleChanged: {
        if (visible)
            forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent

        SwipeView {
            id: swipeview

            Layout.fillHeight: true
            Layout.fillWidth: true

            TutorialSection {
                content: ColumnLayout {
                    width: parent.width
                    spacing: 16

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Hey! Welcome to Switch.")
                        font.pixelSize: 20
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Switch is a game about solving systems of linear equations using the Gaussian elimination of matrices.") + "<br/>" +
                              qsTr("Yeah, I know. That sounds scary. It doesn't really sound like a lot of fun, rather like one of <i>those</i> maths lessons, right? 😉")
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: quote(qsTr("Then let us hope that I was wrong"), qsTr("Morpheus"))
                        color: quoteColor
                        wrapMode: Text.WordWrap
                    }
                }
            }

            TutorialSection {
                content: ColumnLayout {
                    width: parent.width
                    spacing: 8

                    Label {
                        text: qsTr("What is the matrix?")
                        font.pixelSize: 18
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: quote(qsTr("The answer is out there, Neo. It's looking for you, and it will find you if you want it to."), qsTr("Trinity"))
                        color: quoteColor
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("The matrices in Switch are matrices of coefficients of associated systems of linear equations. Consider the following linear system:") + "<br/>" +
                               "1) 1x + 1y = 3 <br/>" +
                               "2) 1x - 1y = 1 <br/>" +
                               qsTr("Now we're removing all the clutter ...") + "<br/>"
                        wrapMode: Text.WordWrap
                    }

                    Image {
                        source: "/images/tutorial/matrix_example_01.svg"
                        transform: Scale {
                            xScale: 0.75
                            yScale: 0.75
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("... and we get a matrix form like the one above.")
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        text: qsTr("Solution?")
                        font.pixelSize: 18
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("In Switch, all matrices have exactly one correct solution.") + " " +
                              qsTr("A solution is an assignment of values to the variables (x, y) such that all equations are correct.") + " " +
                              qsTr("In our case the solution x=2, y=1 satisfies the linear system.")
                        wrapMode: Text.WordWrap
                    }
                }
            }

            TutorialSection {
                content: ColumnLayout {
                    width: parent.width
                    spacing: 16

                    Label {
                        text: qsTr("How to solve a matrix")
                        font.pixelSize: 18
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("There are multiple ways to solve a system of linear equations.") + " " +
                              qsTr("In Switch you will use <a href='https://en.wikipedia.org/wiki/Gaussian_elimination'>Gaussian elimination</a>, also known as row reduction.") + " " +
                              qsTr("Using the Gaussian elimination algorithm you can perform several actions on a matrix of coefficients.") + " " +
                              qsTr("Those actions are called row operations. In Switch you are able to ...") + "<br/>" +
                              qsTr("... multiply a row by a number") + "<br/>" +
                              qsTr("... add one row to another") + "<br/>" +
                              qsTr("The goal of all this is to eliminate variables by setting the coefficient to zero. Remember our example:") + "<br/>"
                        wrapMode: Text.WordWrap
                        linkColor: tutorialPage.linkColor
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Image {
                        source: "/images/tutorial/matrix_example_01.svg"
                        transform: Scale {
                            xScale: 0.75
                            yScale: 0.75
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("To solve this matrix, we would like to eliminate the x variable from the second row.") + " " +
                              qsTr("To achieve this, we'll multiply the first row by -1 and add it to the second row. The result:") + "<br/>"
                        wrapMode: Text.WordWrap
                    }

                    Image {
                        source: "/images/tutorial/matrix_example_02.svg"
                        transform: Scale {
                            xScale: 0.75
                            yScale: 0.75
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("In this simple case, this was the only step needed to solve the system.") +  "<br/>" +
                              qsTr("Our matrix is transformed into upper <a href='https://en.wikipedia.org/wiki/Triangular_matrix'>triangular form</a>, which means that all matix entries below the <a href='https://en.wikipedia.org/wiki/Main_diagonal'>main diagonal</a> are zero.") + " " +
                              qsTr("We can now finish solving the matrix in your head:") + "<br/>" +
                              "1) -1x -1y = -3 <br/>" +
                              "2) -2y = -2 <br/>" +
                              qsTr("Therefore: x = 2, y = 1")
                        wrapMode: Text.WordWrap
                        linkColor: tutorialPage.linkColor
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Alternatively we can continue to simplify the matrix using the row operations ...")
                        wrapMode: Text.WordWrap
                    }

                    Image {
                        source: "/images/tutorial/matrix_example_03.svg"
                        transform: Scale {
                            xScale: 0.75
                            yScale: 0.75
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr(" ... until we end up with the so called reduced <a href='https://en.wikipedia.org/wiki/Row_echelon_form'>row echelon form</a>.") + " " +
                              qsTr("This means that in every row there is exactly one leading coefficient which is 1.") + " " +
                              qsTr("All other entries in the same column are 0.")
                        width: parent.width
                        wrapMode: Text.WordWrap
                        linkColor: tutorialPage.linkColor
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }
            }

            TutorialSection {
                content: ColumnLayout {
                    width: parent.width
                    spacing: 8

                    Label {
                        text: qsTr("And ... action")
                        font.pixelSize: 18
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("In Switch, this all is even more hassle-free. I think it's time to try it yourself.")
                        wrapMode: Text.WordWrap
                    }

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Row operations:") + "<br/>" +
                              "<u>%1</u><br/>".arg(qsTr("Add")) +
                              qsTr("• You can drag and drop a row onto another to add it") + "<br/>" +
                              "<u>%1</u><br/>".arg(qsTr("Multiply")) +
                              qsTr("• Tap on a row to select it") + "<br/>" +
                              qsTr("• The multiply slider will show up") + "<br/>" +
                              qsTr("• Hold and move the slider increase/decrease the value of the mutliplicator, release to multiply") + "<br/>"
                        wrapMode: Text.WordWrap
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Simplify the matrix as much as possible by using the row operations.") + " " +
                                  qsTr("You will end up with the so called reduced <a href='https://en.wikipedia.org/wiki/Row_echelon_form'>row echelon form</a> and Switch will detect that the matrix is solved.")
                            width: parent.width
                            wrapMode: Text.WordWrap
                            linkColor: tutorialPage.linkColor
                            onLinkActivated: Qt.openUrlExternally(link)
                        }

                        Image {
                            Layout.fillWidth: true
                            fillMode: Image.PreserveAspectFit
                            source: "/images/tutorial/matrix_example_03.svg"
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Let's go!")
                        onClicked: tutorialPage.popRequested()
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: quote(qsTr("The problem is choice."), qsTr("Neo"))
                        color: quoteColor
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: 48
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent

                Row {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 8
                    height: 32

                    Repeater {
                        model: swipeview.count

                        Rectangle {
                            color: swipeview.currentIndex == index ? linkColor : quoteColor
                            width: 32
                            height: 32
                            radius: width * 0.5

                            Label {
                                anchors.centerIn: parent
                                text: (index + 1).toString()
                                color: "white"
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    swipeview.currentIndex = index;
                                }
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Keys.onBackPressed: {
        popRequested();
    }
}
