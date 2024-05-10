import QtQuick 2.15
import ".."

Rectangle {
    property alias text: textInput.text
    height: window.height * 0.08
    width:  window.width > window.height ? window.width * 0.5 : window.width * 0.8
    color: "transparent"
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height//window.height * 0.1
        width: parent.width//window.width * 0.5
        spacing: window.height * 0.025
        Rectangle {
            height: parent.height//window.height * 0.1
            width: window.width > window.height ? window.width * 0.4 : window.width * 0.8 - eyeArea.width - window.height * 0.025
            color: style.blue
            radius: height / 8
            clip: true
            Text {
                anchors.fill: parent
                verticalAlignment: TextEdit.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Пароль"
                font.family: lato.name
                color: style.gray
                font.pixelSize: height / 2
                visible: textInput.text === ""
            }
            TextInput {
                id: textInput
                anchors.fill: parent
                color: "white"
                font.pixelSize: height / 2
                verticalAlignment: TextEdit.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                echoMode: TextInput.Password
                state: "hidden"
                states: [
                    State {
                        name: "hidden"
                        PropertyChanges {
                            target: textInput
                            echoMode: TextInput.Password
                        }
                    },
                    State {
                        name: "visible"
                        PropertyChanges {
                            target: textInput
                            echoMode: TextInput.Normal
                        }
                    }
                ]
            }
        }
        Rectangle {
            color: "transparent"
            height: parent.height
            width: height
            border.width: 2
            border.color: style.blue
            radius: height / 2
            MouseArea {
                id: eyeArea
                anchors.fill: parent
                onClicked: {
                  textInput.state = textInput.state === "hidden" ? "visible" : "hidden"
                }
            }
        }
    }
    Styles {id: style}
}
