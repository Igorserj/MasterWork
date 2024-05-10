import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../UIControls"
import "../Backend"

Rectangle {
    id: container
    width: window.width * 0.975
    height: window.height * 0.975
    color: "transparent"
    x: (window.width - width) / 2
    Component.onCompleted: init()
    ScrollView {
        id: msgArea
        clip: true
        width: parent.width
        height: footer.y
        ListView {
            y: msgArea.height - height > 0 ? msgArea.height - height: 0
            verticalLayoutDirection: ListView.BottomToTop
            model: msgModel
            spacing: container.height * 0.01
            delegate: MessageBubble {}
        }
    }
    Repeater {
        model: ["Retrain"]
        MyButton {
            id: btn
            y: -height
            function click(index) {
                const ti = getTariffInfo()
                chat.training(ti, false)
                const info = loginModel.get_user_info()
                chat.user_info(info[10], info[3], info[5])
            }
            SequentialAnimation {
                running: showTrainBtn.containsMouse
                loops: Animation.Infinite
                PropertyAnimation {
                    target: btn
                    property: "y"
                    duration: 250
                    to: 0
                }
                PauseAnimation {
                    duration: 500
                }
            }
            SequentialAnimation {
                running: !showTrainBtn.containsMouse
                PauseAnimation {
                    duration: 2000
                }
                PropertyAnimation {
                    target: btn
                    property: "y"
                    duration: 250
                    to: -btn.height
                }
            }
        }
    }
    MouseArea {
        id: showTrainBtn
        hoverEnabled: true
        width: window.width * 0.05
        height: window.height * 0.05
    }

    InputMessage {
        id: inMsg
        y: footer.y + (footer.height - height) / 2
    }
    ListModel {id: msgModel}

    function init() {
        footer.model = ["На головну"]
        footer.state = "expanded"
        inMsg.x = Qt.binding(()=> 2 * footer.rep.itemAt(0).x + footer.rep.itemAt(0).width)
        inMsg.width = Qt.binding(()=>footer.width - footer.rep.itemAt(0).width - 3 * footer.rep.itemAt(0).x)
        const info = loginModel.get_user_info()
        // [data, calls, sms, balance, update_date, t_name, t_data, t_calls, t_sms, price, user.value(0), tariff]
        chat.user_info(info[10], info[3], info[5])

        const loadedChat = loginModel.load_chat()
        for (let i = 0; i < loadedChat.length; ++i) {
            const userResponse = [0, loadedChat[i][0]]
            msgModel.insert(...userResponse)
            const botResponse = [0, loadedChat[i][1]]
            msgModel.insert(...botResponse)
        }
    }

    function footerAction(index) {
        if (index === 0) {
            loadMain()
        }
    }
}
