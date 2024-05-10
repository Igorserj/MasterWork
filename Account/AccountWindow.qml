import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent
    property var userInfo: [1, 1, 1, 0, '', '', 1, 1, 1, 0]
    Component.onCompleted: init()
    ScrollView {
        width: window.width
        height: footer.y
        clip: true
        // anchors.horizontalCenter: parent.horizontalCenter
        Column {
            x: (window.width - width) / 2
            Loader {
                id: layoutLoader
                active: false
                sourceComponent: window.width > window.height ? horizontalLayout : verticalLayout
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                height: 0.1 * window.height
                width: 0.75 * window.width
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Text {
                    text: "Ваш баланс: " + userInfo[3] + " грн"
                    font.family: lato.name
                    color: "white"
                    anchors.fill: parent
                    fontSizeMode: Text.HorizontalFit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height / 2
                }
            }
            Rectangle {
                height: 0.1 * window.height
                width: 0.75 * window.width
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Text {
                    text: "Дата онвлення пакета: " + userInfo[4]
                    font.family: lato.name
                    color: "white"
                    anchors.fill: parent
                    fontSizeMode: Text.HorizontalFit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height / 2
                }
            }
            Rectangle {
                height: 0.1 * window.height
                width: 0.75 * window.width
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Text {
                    text: "Вартість пакета послуг: " + userInfo[9] + " грн"
                    font.family: lato.name
                    color: "white"
                    anchors.fill: parent
                    fontSizeMode: Text.HorizontalFit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: height / 2
                }
            }
        }
    }

    Component {
        id: horizontalLayout
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: [{service: "Інтернет", current: userInfo[0], max: userInfo[6]}, {service: "Дзвінки", current: userInfo[1], max: userInfo[7]}, {service: "СМС", current: userInfo[2], max: userInfo[8]}]
                Column {
                    Rectangle {
                        height: 0.1 * window.height
                        width: 0.2 * window.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        Text {
                            text: modelData.service
                            font.family: lato.name
                            color: "white"
                            anchors.fill: parent
                            fontSizeMode: Text.HorizontalFit
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: height / 2
                        }
                    }
                    Canvas {
                        id: myCanvas
                        width: 0.3 * window.width
                        height: width
                        onPaint: {
                            const ctx = myCanvas.getContext("2d");
                            const centerX = myCanvas.width / 2;
                            const centerY = myCanvas.height / 2;
                            let radius = myCanvas.width / 4;

                            // Data for the sectors (percentages)
                            let max = modelData.max
                            if (modelData.max === 0) max = 1
                            let sectorData = modelData.current / max * 100; // Example data
                            let currentAngle = -Math.PI / 2 // Start from the top
                            let colors = "green"; // Example colors
                            let sectorAngle = (sectorData / 100) * (2 * Math.PI);
                            let endAngle = currentAngle + sectorAngle;// Math.PI + (Math.PI * 1) / 2

                            ctx.beginPath();
                            ctx.arc(centerX, centerY, radius, currentAngle, endAngle);
                            ctx.lineTo(centerX, centerY);
                            ctx.strokeStyle = colors;
                            ctx.lineWidth = 10;
                            ctx.lineCap = "round";
                            ctx.stroke();
                        }
                    }
                    Rectangle {
                        height: 0.1 * window.height
                        width: 0.2 * window.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        Text {
                            text: (Math.round(modelData.current*100) / 100) + " / " + (modelData.max === -1 ? '∞' : modelData.max)
                            font.family: lato.name
                            color: "white"
                            fontSizeMode: Text.HorizontalFit
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: height / 2
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }

    Component {
        id: verticalLayout
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                model: [{service: "Інтернет", current: userInfo[0], max: userInfo[6]}, {service: "Дзвінки", current: userInfo[1], max: userInfo[7]}, {service: "СМС", current: userInfo[2], max: userInfo[8]}]
                Row {
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            height: 0.1 * window.height
                            width: 0.2 * window.width
                            color: "transparent"
                            Text {
                                text: modelData.service
                                font.family: lato.name
                                color: "white"
                                anchors.fill: parent
                                fontSizeMode: Text.HorizontalFit
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: height / 2
                            }
                        }
                        Rectangle {
                            height: 0.1 * window.height
                            width: 0.2 * window.width
                            color: "transparent"
                            Text {
                                text: (Math.round(modelData.current*100) / 100) + " / " + (modelData.max === -1 ? '∞' : modelData.max)
                                font.family: lato.name
                                color: "white"
                                fontSizeMode: Text.HorizontalFit
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: height / 2
                                anchors.fill: parent
                            }
                        }
                    }
                    Canvas {
                        id: myCanvas
                        width: 0.3 * window.width
                        height: width
                        onPaint: {
                            const ctx = myCanvas.getContext("2d");
                            const centerX = myCanvas.width / 2;
                            const centerY = myCanvas.height / 2;
                            let radius = myCanvas.width / 4;

                            // Data for the sectors (percentages)
                            let max = modelData.max
                            if (modelData.max === 0) max = 1
                            let sectorData = modelData.current / max * 100; // Example data
                            let currentAngle = -Math.PI / 2 // Start from the top
                            let colors = "green"; // Example colors
                            let sectorAngle = (sectorData / 100) * (2 * Math.PI);
                            let endAngle = currentAngle + sectorAngle;// Math.PI + (Math.PI * 1) / 2

                            ctx.beginPath();
                            ctx.arc(centerX, centerY, radius, currentAngle, endAngle);
                            ctx.lineTo(centerX, centerY);
                            ctx.strokeStyle = colors;
                            ctx.lineWidth = 10;
                            ctx.lineCap = "round";
                            ctx.stroke();
                        }
                    }
                }
            }
        }
    }

    function init() {
        footer.model = ["На головну", "Вихід"]
        const info = loginModel.get_user_info()
        if (info[0] !== false) userInfo = info
        layoutLoader.active = true
    }

    function footerAction(index) {
        if (index === 0) {
            loadMain()
        }
        else if (index === 1) {
            loginModel.logout()
            loadMain()
        }
    }
}
