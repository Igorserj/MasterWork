import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: container
    width: window.width
    height: footer.y //window.height * 0.975
    clip: true
    Component.onCompleted: init()
    ScrollView {
        id: servicesArea
        clip: true
        width: window.width
        height: window.height * 0.7
        ListView {
            orientation: ListView.Horizontal
            // layoutDirection: Qt.LeftToRight
            model: tariffModel
            spacing: container.width * 0.01
            delegate: Tablet {}
        }
    }

    ListModel {id: tariffModel}


    function init() {
        footer.model = ["На головну"]
        const tariffs = loginModel.get_tariff_info() //Tariff_name, Data, Calls, SMS, Price
        for (let i = 1; i < tariffs.length; ++i) {
            // console.log(tariffs[i][0])
            tariffModel.append({t_name: tariffs[i][0], t_data: tariffs[i][1], t_calls: tariffs[i][2], t_sms: tariffs[i][3], t_price: tariffs[i][4]})
        }
    }

    function footerAction(index) {
        if (index === 0) {
            loadMain()
        }
    }
}
