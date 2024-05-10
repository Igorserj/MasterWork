import QtQuick 2.15
import QtQuick.Controls 2.15
import AccountModel 1.0
import ChatModel 1.0
import "Account"
import "UIControls"
import "Services"
import "Chat/UI"

ApplicationWindow {
    id: window
    property string orientation: width > height ? "horizontal" : "vertical"
    visible: true
    width: 600
    height: 500
    title: "Master work of Serhiienko Ihor"
    Component.onCompleted: { loadMain(); init() }
    FooterControls {
        id: footer
    }
    Loader {
        id: contentLoader
        anchors.fill: parent
    }

    NotificationWindow {
        id: notify
    }

    SqlLoginModel { id: loginModel }

    Chat { id: chat }

    FontLoader { id: lato; source: "Fonts/Lato-Regular.ttf" }

    Component {
        id: loginWindow
        LoginWindow {}
    }
    Component {
        id: accountWindow
        AccountWindow {}
    }
    Component {
        id: mainMenu
        MainMenu {}
    }

    Component {
        id: chatbotInterface
        UserInterface {}
    }
    Component {
        id: servciesWindow
        Services {}
    }

    function init() {
        const ti = getTariffInfo()
        chat.training(ti, true)
    }

    function getTariffInfo() {
        return loginModel.get_tariff_info()
    }

    function loadMain() {
        contentLoader.sourceComponent = mainMenu
        footer.model = []
    }

    function loadLogin() {
        contentLoader.sourceComponent = loginWindow
    }

    function loadServices() {
        contentLoader.sourceComponent = servciesWindow
    }

    function loadAccount() {
        contentLoader.sourceComponent = accountWindow
    }

    function loadChatbot() {
        contentLoader.sourceComponent = chatbotInterface
    }
}
