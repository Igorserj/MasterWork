import QtQuick 2.15
import "../UIControls"

Item {
    anchors.fill: parent
    Component.onCompleted: init()
    Column {
        x: (parent.width - mf.width) / 2
        anchors.verticalCenter: parent.verticalCenter
        spacing: window.height * 0.025
        MobileField {id: mf}
        PasswordField {id: pf}
        Repeater {
            model: ["Вхід"]
            MyButton {
                id: sendButton
                x: (mf.width - width) / 2
                buttonArea.onClicked: {
                    if (mf.text.length !== 17) notify.notification = "Неправильний формат номера"
                    else if (pf.text.length === 0) notify.notification = "Введіть пароль"
                    else {
                        const number = mf.text.replace(/[+-\s]/g, "").substring(2)
                        const password = pf.text.replace(/[\s]/g, "")
                        let result = loginModel.login(number, password)
                        notify.notification = result[0]
                        if (result[1]) {
                            loadAccount()
                        }
                    }
                }
            }
        }
    }

    function init() {
        footer.model = ["На головну"]
        let result = loginModel.auto_login()
        if (result[1]) {
            loadAccount()
        }
    }

    function footerAction(index) {
        if (index === 0) {
            loadMain()
        }
    }
}
