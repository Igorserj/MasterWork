import QtQuick 2.15
import ".."

Rectangle {
    id: footer
    property alias model: rep.model
    property alias rep: rep
    color: style.blackGlass
    radius: height / 4
    height: footer.childrenRect.height + window.height * 0.0125
    x: (window.width - footer.width) / 2
    state: "hidden"
    states: [
        State {
            name: "base"
            when: rep.model.length > 0
            PropertyChanges {
                target: footer
                width: window.width * 0.9
                radius: footer.height / 4
                y: window.height * 0.9875 - footer.height
            }
        },
        State {
            name: "hidden"
            when: rep.model.length === 0
            PropertyChanges {
                target: footer
                y: window.height
                radius: footer.height / 4
                width: window.width * 0.9
            }
        },
        State {
            name: "expanded"
            PropertyChanges {
                target: footer
                width: window.width
                radius: 0
                y: window.height - footer.height
            }
        }
    ]
    Behavior on y {
        PropertyAnimation {
            target: footer
            property: "y"
            duration: 250
            easing.type: Easing.OutBack
        }
    }
    Behavior on x {
        PropertyAnimation {
            target: footer
            property: "x"
            duration: 250
        }
    }
    Behavior on width {
        PropertyAnimation {
            target: footer
            property: "width"
            duration: 250
        }
    }
    Behavior on height {
        PropertyAnimation {
            target: footer
            property: "height"
            duration: 250
        }
    }

    Repeater {
        id: rep
        MyButton {
            x: index === 0 ? window.height * 0.0125 : footer.width - width - window.height * 0.0125
            y: window.height * 0.0125
            function click(index) { contentLoader.item.footerAction(index) }
        }
    }

    Styles {id: style}
}
