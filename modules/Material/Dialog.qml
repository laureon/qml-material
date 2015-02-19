/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014 Michael Spencer
 * Copyright (C) 2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
 * Copyright (C) 2015 Mikhail Ivchenko <ematirov@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
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
import Material 0.1
import Material.Extras 0.1

Popover {
    id: dialog

    anchor: Item.Center

    overlayLayer: "dialogOverlayLayer"

    backdropColor: Qt.rgba(0, 0, 0, 0.3)

    width: Math.max(dialogContainer.width, minimumWidth)
    height: dialogContainer.height

    property int minimumWidth: units.dp(240)

    property alias title: titleLabel.text

    property string negativeButtonText: "CANCEL"
    property string positiveButtonText: "OK"

    property bool hasActions: true

    default property alias dialogContent: placeholder.children

    signal accepted()
    signal rejected()

    transitions: [
        Transition {
            ParallelAnimation {
                NumberAnimation {
                    target: internalView
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: internalView
                    property: "width"
                    duration: 100
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: internalView
                    property: "height"
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    ]

    Item {
        id: dialogContainer
        width: Math.max(minimumWidth,
                        (placeholder.childrenRect.width +
                        placeholder.anchors.leftMargin +
                        placeholder.anchors.rightMargin))

        height: titleLabel.height +
                titleLabel.anchors.topMargin +
                placeholder.childrenRect.height +
                placeholder.anchors.topMargin +
                placeholder.anchors.bottomMargin +
                buttonContainer.height

        Label {
            id: titleLabel
            height: implicitHeight
            style: "title"
            anchors {
                top: parent.top
                topMargin: units.dp(16)
                left: parent.left
                leftMargin: units.dp(16)
            }
        }

        Item {
            z: parent.z + 5
            anchors {
                left: parent.left
                leftMargin: units.dp(16)
                right: parent.right
                rightMargin: units.dp(16)
                top: titleLabel.bottom
                topMargin: units.dp(16)
                bottom: buttonContainer.top
                bottomMargin: hasActions ? 0 : units.dp(16)
            }
            id: placeholder
        }

        Item {
            id: buttonContainer
            z: parent.z + 5
            width: negativeButton.width + positiveButton.width + units.dp(24)
            height: hasActions ? units.dp(64) : 0
            visible: hasActions

            anchors {
                bottom: parent.bottom
                right: parent.right
            }

            Button {
                id: negativeButton

                text: negativeButtonText
                textColor: Theme.accentColor
                anchors {
                    top: parent.top
                    topMargin: units.dp(8)
                    right: positiveButton.left
                    rightMargin: units.dp(8)
                    bottom: parent.bottom
                    bottomMargin: units.dp(8)
                }
                onClicked: {
                    close();
                    rejected();
                }
            }

            Button {
                id: positiveButton

                text: positiveButtonText
                textColor: Theme.accentColor
                anchors {
                    top: parent.top
                    topMargin: units.dp(8)
                    right: parent.right
                    rightMargin: units.dp(16)
                    bottom: parent.bottom
                    bottomMargin: units.dp(8)
                }
                onClicked: {
                    close()
                    accepted();
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false
            onClicked: {
                mouse.accepted = false
            }
        }
    }

    function show() {
        open(parent)
    }
}
