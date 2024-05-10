import QtQuick 2.15
import "UIControls"

Item {
    id: mainMenu
    anchors.fill: parent
    property var buttons: ["Акаунт", "Послуги і тарифи", "Підтримка"]
    function buttonsAction(index) {
        switch (index) {
            case 0: loadLogin(); break
            case 1: loadServices(); break
            case 2: loadChatbot(); break
        }
    }
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: window.height * 0.025
        Repeater {
            model: buttons
            MyButton {
                anchors.horizontalCenter: parent.horizontalCenter
                function click(index) { buttonsAction(index) }
            }
        }
    }
}
