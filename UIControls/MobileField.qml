import QtQuick 2.15
import ".."

Rectangle {
    property alias text: textInput.text
    height: window.height * 0.08
    width:  window.width > window.height ? window.width * 0.4 : window.width * 0.8
    color: "transparent"
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height//window.height * 0.1
        width: parent.width//window.width * 0.4
        spacing: window.height * 0.025
        Rectangle {
            height: parent.height// window.height * 0.1
            width:  parent.width// window.width * 0.4
            color: style.blue
            radius: height / 8
            clip: true
            Text {
                anchors.fill: parent
                verticalAlignment: TextEdit.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Моб. номер"
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
                inputMask: "+389 99 999-99-99;X"
            }
        }
    }
    Styles {
        id: style
    }
}
