import QtQuick 2.15
import "../.."

Rectangle {
    id: sendBtn
    height: parent.height * 0.95
    width: height
    radius: height / 2
    x: inContainer.width - width
    y: (inContainer.height - height) / 2
    color: style.darkBlue

    MouseArea {
        anchors.fill: parent
        onClicked: clickAction()
    }

    function clickAction() {
        if (inputText.text !== '') {
            const msg = inputText.text
            inputText.text = ''
            const userResponse = [0, {text: msg, type: 'user'}]
            msgModel.insert(...userResponse)
            const botResponse = [0, chat.send_action(msg)[0]]
            msgModel.insert(...botResponse)
            loginModel.saving_chat(userResponse[1].text, botResponse[1].text)
        }
    }

    Styles {id: style}
}
