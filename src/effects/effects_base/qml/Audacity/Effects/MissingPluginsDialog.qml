import QtQuick 2.15

import Muse.UiComponents

StyledDialogView {
    title: qsTr("Missing plugins")

    contentWidth: 300
    contentHeight: 200

    Rectangle {
        anchors.fill: parent
        color: "salmon"
    }
}
