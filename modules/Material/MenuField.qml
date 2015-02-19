import QtQuick 2.2
import QtQuick.Layouts 1.1

import Material 0.1
import Material.ListItems 0.1


Item {
    id: field

    implicitHeight: hasHelperText ? helperTextLabel.y + helperTextLabel.height + units.dp(4)
                                  : underline.y + units.dp(8)
    implicitWidth: spinBox.width

    activeFocusOnTab: true

    property color accentColor: Theme.accentColor
    property color errorColor: "#F44336"

    property alias model: listView.model
    readonly property string selectedText: listView.currentItem.text
    property alias selectedIndex: listView.currentIndex
    property int maxVisibleItems: 4

    property alias placeholderText: fieldPlaceholder.text
    property alias helperText: helperTextLabel.text

    property bool floatingLabel: false
    property bool hasError: false
    property bool hasHelperText: helperText.length > 0

    readonly property rect inputRect: Qt.rect(spinBox.x, spinBox.y, spinBox.width, spinBox.height)

    signal itemSelected(int index)

    Ink {
        anchors.fill: parent
        onClicked: {
            listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
            var offset = listView.currentItem.itemLabel.mapToItem(menu, 0, 0)
            menu.open(label, -offset.x, -offset.y)
        }
    }

    Item {
        id: spinBox

        height: units.dp(24)
        width: spinBoxContents.implicitWidth

        y: {
            if(!floatingLabel)
                return units.dp(16)
            if(floatingLabel && !hasHelperText)
                return units.dp(40)
            return units.dp(28)
        }

        RowLayout {
            id: spinBoxContents

            height: parent.height
            width: parent.width + units.dp(5)

            Label {
                id: label

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                text: listView.currentItem.text
                style: "subheading"
                elide: Text.ElideRight
            }

            Icon {
                id: dropDownIcon

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Layout.preferredWidth: units.dp(24)
                Layout.preferredHeight: units.dp(24)

                name: "navigation/arrow_drop_down"
                size: units.dp(24)
            }
        }

        Dropdown {
            id: menu

            anchor: Item.TopLeft

            width: Math.max(units.dp(56*2), Math.min(spinBox.width - 2 * x, listView.contentWidth))
            //If there are more than max items, show an extra half item so it's clear the user can scroll
            height: Math.min(maxVisibleItems*units.dp(48) + units.dp(24), listView.contentHeight)

            ListView {
                id: listView

                width: menu.width
                height: menu.height

                interactive: true

                delegate: Standard {
                    id: delegateItem

                    text: modelData

                    onTriggered: {
                        itemSelected(index)
                        listView.currentIndex = index
                        menu.close()
                    }
                }
            }

            Scrollbar {
                flickableItem: listView
            }
        }
    }

    Label {
        id: fieldPlaceholder

        text: field.placeholderText
        visible: floatingLabel

        font.pixelSize: units.dp(12)

        anchors.bottom: spinBox.top
        anchors.bottomMargin: units.dp(8)

        color: Theme.light.hintColor
    }

    Rectangle {
        id: underline

        color: field.hasError ? field.errorColor : field.activeFocus ? field.accentColor : Theme.light.hintColor

        height: field.activeFocus ? units.dp(2) : units.dp(1)

        anchors {
            left: parent.left
            right: parent.right
            top: spinBox.bottom
            topMargin: units.dp(8)
        }

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    Label {
        id: helperTextLabel

        anchors {
            left: parent.left
            right: parent.right
            top: underline.top
            topMargin: units.dp(4)
        }

        visible: hasHelperText
        font.pixelSize: units.dp(12)
        color: field.hasError ? field.errorColor : Qt.darker(Theme.light.hintColor)

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
