import QtQuick 2.0
import QtQuick.Controls 2.0

Page {
    id: aboutPage

    property color linkColor: "#388E3C"

    signal popRequested()

    title: qsTr("About")
    visible: false

    onVisibleChanged: {
        if (visible)
            forceActiveFocus();
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        contentHeight: contentItem.height + contentItem.padding * 2

        Item {
            id: contentItem
            property int padding: 16
            x: padding
            y: padding
            width: parent.width - (2 * padding)
            height: childrenRect.height

            Column {
                width: parent.width
                spacing: 8

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Switch Reloaded"
                    font.pixelSize: 18
                }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/icon/icon_512.png"
                    width: 64
                    height: 64
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("A simple game about linear equations")
                }

                Label {
                    text: qsTr("About")
                    font.pixelSize: 18
                }

                Label {
                    text: qsTr('Switch Reloaded is a platform independent successor of the popular <a href="%1">Ubuntu Phone game "Switch"</a>.')
                           .arg("https://uappexplorer.com/app/switch.timsueberkrueb")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    linkColor: aboutPage.linkColor
                    onLinkActivated: Qt.openUrlExternally(link);
                }

                Label {
                    text: qsTr("Credits")
                    font.pixelSize: 18
                }

                Label {
                    text: qsTr("Many thanks to <a href='%1'>Andrew Penkrat</a> for his help and contribution ensuring Switch generates systems with one and only one solution 😉.")
                           .arg("https://github.com/aldrog")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    linkColor: aboutPage.linkColor
                    onLinkActivated: Qt.openUrlExternally(link);
                }

                Label {
                    text: qsTr("Thanks to <a href='%1'>Stuart Langridge</a> for testing, design input and QA of Switch for Ubuntu Phone.").arg("https://github.com/stuartlangridge")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    linkColor: aboutPage.linkColor
                    onLinkActivated: Qt.openUrlExternally(link);
                }

                Label {
                    text: qsTr("License and Copyright")
                    font.pixelSize: 18
                }

                Label {
                    text: qsTr("Source code available on <a href='%1'>GitHub</a>.").arg("https://github.com/tim-sueberkrueb/switch")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    linkColor: aboutPage.linkColor
                    onLinkActivated: Qt.openUrlExternally(link);
                }

                Label {
                    text: qsTr("Switch Reloaded contains icons from the <a href='%1'>Ionicons icon set</a> which are licensed under the <a href='%2'>MIT license</a>.").arg("http://ionicons.com/").arg("https://opensource.org/licenses/MIT")
                    width: parent.width
                    wrapMode: Text.WordWrap
                    linkColor: aboutPage.linkColor
                    onLinkActivated: Qt.openUrlExternally(link);
                }

                Label {
                    text: ("This application is free software: you can redistribute it and/or modify it under the terms of" +
                           " the GNU General Public License as published by the Free Software Foundation, either version 3 of the " +
                           "License, or (at your option) any later version.<br/><br/>Copyright © 2016-2017 Tim Süberkrüb and contributors.<br/>")
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8

                    Button {
                        text: qsTr("Rate")
                        onClicked: {
                            Qt.openUrlExternally("market://details?id=io.timsueberkrueb.swichreloaded")
                        }
                    }

                    Button {
                        text: qsTr("Report bug")
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/tim-sueberkrueb/switch-reloaded/issues/new");
                        }
                    }

                    Button {
                        text: qsTr("Contribute")
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/tim-sueberkrueb/switch-reloaded");
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
