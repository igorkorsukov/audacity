/*
 * Audacity: A Digital Audio Editor
 */
import QtQuick
import QtQuick.Layouts

import Muse.Ui
import Muse.UiComponents

StyledDialogView {
    id: root

    title: qsTrc("effects", "Missing plugins")

    contentWidth: 480
    contentHeight: 280

    margins: 12

    property var missingPlugins: null

    // Workaround: the dialog is opened during project-page construction,
    // whose async focus transitions (e.g. MainToolBar's onActiveChanged)
    // steal focus from the dialog after it opens. Re-request focus until
    // it sticks. A proper fix would defer opening the dialog until the
    // project page is fully constructed, but that would require a
    // dependency from effects_base on appshell.
    Timer {
        id: refocusTimer
        interval: 100
        repeat: true
        running: root.isOpened
        onTriggered: {
            if (okButton.navigation.active) {
                refocusTimer.stop()
            } else {
                okButton.navigation.requestActive()
            }
        }
    }

    NavigationPanel {
        id: navigationPanel

        name: "MissingPluginsPanel"
        section: root.navigationSection
        order: 0
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            StyledIconLabel {
                Layout.alignment: Qt.AlignTop
                iconCode: IconCode.WARNING
                font.pixelSize: 32
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                StyledTextLabel {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    text: qsTrc("effects", "Missing plugins")
                    font: ui.theme.headerBoldFont
                }

                StyledTextLabel {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    text: qsTrc("effects", "Some plugins used in this project were not found:")
                }
            }
        }

        TextInputArea {
            Layout.fillWidth: true
            Layout.fillHeight: true

            navigation.panel: navigationPanel
            navigation.order: okButton.navigation.order + 1
            navigation.name: "MissingPluginsList"

            currentText: (root.missingPlugins || []).map(function (name) {
                return "\u2022  " + name
            }).join("\n")

            Component.onCompleted: {
                inputField.readOnly = true
                inputField.activeFocusOnPress = true
                inputField.persistentSelection = true
            }

            Keys.onShortcutOverride: function (event) {
                if (event.matches(StandardKey.Copy) || event.matches(StandardKey.SelectAll)) {
                    event.accepted = true
                }
            }
        }

        FlatButton {
            id: okButton

            Layout.alignment: Qt.AlignRight

            navigation.panel: navigationPanel
            navigation.order: 0
            navigation.name: "OK"

            text: qsTrc("effects", "OK")

            onClicked: {
                root.accept()
            }
        }
    }
}
