import QtQuick 2.15
import "../.."

Rectangle {
    id: msgBubble
    property double maxW: container.width * 0.6
    property real minH: container.height * 0.08
    property string message: text
    width: msgItem.width
    height: msgItem.height
    radius: minH / 2
    states: [
        State {
            name: "user"
            when: type === "user"
            PropertyChanges {
                target: msgBubble
                color: style.blue
                anchors.right: msgBubble.parent.right
                anchors.rightMargin: msgArea.width * 0.02
                // x: msgArea.width * 0.96 - msgBubble.width
            }
        },
        State {
            name: "bot"
            when: type === "bot"
            PropertyChanges {
                target: msgBubble
                color: style.green
                anchors.left: msgBubble.parent.left
                anchors.leftMargin: msgArea.width * 0.02
                // x: msgArea.width * 0.04
            }
        }
    ]
    Item {
        id: msgItem
        width: msgText.paintedWidth + parent.radius * 2
        height: msgText.implicitHeight + parent.radius
        x: parent.radius
        clip: true
        Text {
            id: msgText
            text: message
            y: msgBubble.radius / 2
            height: minH
            width: maxW
            font.family: lato.name
            color: "white"
            font.pixelSize: height * 0.4
            wrapMode: Text.Wrap
        }
    }
    Styles {id: style}
}
