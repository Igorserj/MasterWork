import QtQuick 2.15
import ".."

Rectangle {
    id: tablet
    color: "transparent"
    border.width: window.width * 0.01
    border.color: style.blackGlass
    width: servicesArea.width * 0.7
    height: servicesArea.height
    radius: height / 8
    // y: servicesArea.height * 0.05
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            height: tablet.height * 0.2
            width: tablet.width * 0.8
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: t_name
                font.family: lato.name
                anchors.fill: parent
                color: "white"
                font.pixelSize: height / 2
                fontSizeMode: Text.Fit
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                // horizontalAlignment: Text.AlignRight
            }
        }
        Repeater {
            model: ["Інтернет (ГБ): ", "Дзвінки (хв): ", "СМС (шт): ", "Ціна (грн): "]
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    height: tablet.height * 0.15
                    width: text.contentWidth
                    color: "transparent"
                    Text {
                        id: text
                        text: modelData + ([t_data, t_calls, t_sms, t_price][index] === -1 ? '∞' : [t_data, t_calls, t_sms, t_price][index])
                        font.family: lato.name
                        anchors.fill: parent
                        color: "white"
                        font.pixelSize: height / 2
                        fontSizeMode: Text.Fit
                        // horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }

    Styles { id: style }
}
