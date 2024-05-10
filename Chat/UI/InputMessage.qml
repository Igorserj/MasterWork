import QtQuick 2.15
import "../.."

Item {
    id: inContainer
    height: parent.height * 0.08
    width: parent.width
    SendButton {
        id: sendBtn
    }
    Rectangle {
        id: inMsg
        radius: height / 8
        width: parent.width
        height: parent.height
        color: style.blue
        state: "maxi"
        states: [
            State {
                name: "mini"
                when: inputText.text.length > 0
                PropertyChanges {
                    target: inMsg
                    width: inContainer.width - sendBtn.width * 1.2
                }
            },
            State {
                name: "maxi"
                when: inputText.text.length === 0
                PropertyChanges {
                    target: inMsg
                    width: inContainer.width
                }
            }
        ]
        Behavior on width {
            PropertyAnimation {
                target: inMsg
                property: "width"
                duration: 500
            }
        }
        Item {
            id: inputItem
            clip: true
            width: parent.width - parent.radius * 2
            height: parent.height
            x: parent.radius
            TextInput {
                id: inputText
                anchors.fill: parent
                font.family: lato.name
                color: "white"
                verticalAlignment: TextEdit.AlignVCenter
                font.pixelSize: height * 0.4
                wrapMode: TextEdit.Wrap
                onAccepted: sendBtn.clickAction()
            }
            Text {
                id: placeholder
                anchors.fill: parent
                font.family: lato.name
                verticalAlignment: TextEdit.AlignVCenter
                font.pixelSize: parent.height * 0.4
                wrapMode: TextEdit.Wrap
                states: [
                    State {
                        when: inputText.length === 0
                        name: "waiting"
                        PropertyChanges {
                            target: placeholder
                            text: "Введіть запит..."
                            color: style.gray
                            enabled: true
                        }
                    },
                    State {
                        when: inputText.length > 0
                        name: "input"
                        PropertyChanges {
                            target: placeholder
                            text: ""
                            color: "transparent"
                            enabled: false
                        }
                    }
                ]
            }
        }
    }
    Styles {id: style}
}
