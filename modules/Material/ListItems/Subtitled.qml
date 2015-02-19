/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Jordan Neidlinger <jneidlinger@barracuda.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import QtQuick.Layouts 1.1
import ".."

BaseListItem {
    id: listItem

    height: maximumLineCount == 2 ? units.dp(72) : units.dp(88)

    property alias text: label.text
    property alias subText: subLabel.text
    property alias valueText: valueLabel.text

    property alias action: actionItem.children
    property alias secondaryItem: secondaryItem.children

    dividerInset: actionItem.children.length === 0 ? 0 : listItem.height

    property int maximumLineCount: 2

    GridLayout {
        anchors.fill: parent

        anchors.leftMargin: listItem.margins
        anchors.rightMargin: listItem.margins

        columns: 4
        rows: 1
        columnSpacing: units.dp(16)

        Item {
            id: actionItem

            Layout.preferredWidth: children.length === 0 ? 0 : units.dp(40)
            Layout.preferredHeight: width
            Layout.alignment: Qt.AlignCenter
            Layout.column: 1

            visible: childrenRect.width > 0
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.column: 2

            spacing: units.dp(3)

            RowLayout {
                Layout.fillWidth: true

                spacing: units.dp(8)

                Label {
                    id: label

                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    elide: Text.ElideRight
                    style: "subheading"
                }

                Label {
                    id: valueLabel

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: visible ? implicitWidth : 0

                    color: Theme.light.subTextColor
                    elide: Text.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    style: "body1"
                    visible: text != ""
                }
            }

            Label {
                id: subLabel

                Layout.fillWidth: true
                Layout.preferredHeight: implicitHeight * maximumLineCount/lineCount

                color: Theme.light.subTextColor
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                style: "body1"

                visible: text != ""
                maximumLineCount: listItem.maximumLineCount - 1
            }
        }

        Item {
            id: secondaryItem
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height
            Layout.column: 4

            visible: childrenRect.width > 0
        }
    }
}
