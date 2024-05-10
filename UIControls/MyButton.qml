import QtQuick 2.15
import ".."

Rectangle {
    id: button
    property alias buttonArea: buttonArea
    width: buttonText.contentWidth + window.height * 0.025
    height: buttonText.contentHeight + window.height * 0.025
    radius: height / 8
    color: style.green
    border.width: 0
    clip: true
    state: "base"
    states: [
        State {
            name: "base"
            when: !buttonArea.containsMouse
            PropertyChanges {
                target: button
                color: style.green
                radius: height / 8
            }
        },
        State {
            name: "chosen"
            when: buttonArea.containsMouse
            PropertyChanges {
                target: button
                color: style.darkGreen
                radius: height / 4
            }
        }
    ]
    Behavior on color {
        ColorAnimation {
            target: button
            duration: 250
        }
    }
    Behavior on radius {
        PropertyAnimation {
            target: button
            property: "radius"
            duration: 250
        }
    }
    function click(index) {}

    Text {
        id: buttonText
        x: (parent.width - contentWidth) / 2
        y: (parent.height - contentHeight) / 2
        height: window.height * 0.08
        font.pixelSize: height / 2
        text: modelData
        font.family: lato.name
        color: "white"
        fontSizeMode: Text.VerticalFit
    }
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: click(index)
    }

    Styles {
        id: style
    }
}
