import QtQuick 2.15
import ".."

Rectangle {
    id: notifRect
    property string notification: ""
    x: (window.width - width) / 2
    y: -height// window.height * 0.1 - height
    width: text.contentWidth + window.width * 0.01
    height: text.contentHeight + window.height * 0.01
    radius: height / 8
    color: style.blackGlass//"#99222222"
    Rectangle {
        color: "transparent"
        width: text.contentWidth
        height: text.contentHeight
        clip: true
        x: window.width * 0.01 / 2
        y: window.height * 0.01 / 2
        Text {
            id: text
            text: notification
            font.family: lato.name
            width: window.width * 0.3 * 0.975
            height: window.height * 0.1 * 0.975
            font.pixelSize: height / 2.5
            color: "white"
            wrapMode: Text.Wrap
        }
    }
    SequentialAnimation {
        running: notification.length > 0
        PropertyAnimation {
            target: notifRect
            property: "y"
            duration: 250
            easing.type: "OutBack"
            to: window.height * 0.1
        }
        PauseAnimation {
            duration: 2000
        }
        PropertyAnimation {
            target: notifRect
            property: "y"
            duration: 250
            to: -notifRect.height
            easing.type: "InBack"
        }
        ScriptAction {script: notifRect.notification = ""}
    }

    Styles {id: style}
}
