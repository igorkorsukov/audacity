import QtQuick

import Muse.UiComponents

import Audacity.ProjectScene

Item {

    id: root

    property alias trackId: clipsModel.trackId
    property alias context: clipsModel.context

    property bool isDataSelected: false

    signal interactionStarted()
    signal interactionEnded()

    height: trackViewState.trackHeight

    ClipsListModel {
        id: clipsModel

        onRequestClipTitleEdit: function(index){
            repeator.itemAt(index).editTitle()
        }
    }

    TracksViewStateModel {
        id: trackViewState
        trackId: root.trackId
    }

    Component.onCompleted: {
        trackViewState.init()
        clipsModel.init()
    }

    Item {
        anchors.fill: parent
        anchors.bottomMargin: sep.height

        Repeater {
            id: repeator

            model: clipsModel

            // delegate: ClipItem {

            //     property int modelIndex: model.index
            //     property real modelClipWidth: model.clipWidth
            //     property real modelClipLeft: model.clipLeft
            //     property string modelClipTitle: model.clipTitle
            //     property color modelClipColor: model.clipColor
            //     property var modelClipKey: model.clipKey
            //     property real modelClipMoveMaximumX: model.clipMoveMaximumX
            //     property real modelClipMoveMinimumX: model.clipMoveMinimumX

            //     height: parent.height
            //     width: modelClipWidth
            //     x: modelClipLeft

            //     context: root.context
            //     title: modelClipTitle
            //     clipColor: modelClipColor
            //     clipKey: modelClipKey
            //     clipSelected: clipsModel.selectedClipIdx === modelIndex
            //     collapsed: trackViewState.isTrackCollapsed

            //     dragMaximumX: modelClipMoveMaximumX + borderWidth
            //     dragMinimumX: modelClipMoveMinimumX - borderWidth

            //     onPositionChanged: function(x) {
            //         model.clipLeft = x
            //     }

            //     onRequestSelected: {
            //         clipsModel.selectClip(modelIndex)
            //     }

            //     onTitleEditStarted: {
            //         clipsModel.selectClip(modelIndex)
            //     }

            //     onTitleEditAccepted: function(newTitle) {
            //         model.clipTitle = newTitle
            //         clipsModel.resetSelectedClip()
            //     }

            //     onTitleEditCanceled: {
            //         clipsModel.resetSelectedClip()
            //     }
            // }

            delegate: Component {
                Loader {
                    id: loader
                    property int modelIndex: model.index
                    property real modelClipWidth: model.clipWidth
                    property real modelClipLeft: model.clipLeft
                    property string modelClipTitle: model.clipTitle
                    property color modelClipColor: model.clipColor
                    property var modelClipKey: model.clipKey
                    property real modelClipMoveMaximumX: model.clipMoveMaximumX
                    property real modelClipMoveMinimumX: model.clipMoveMinimumX

                    height: parent.height
                    width: model.clipWidth
                    x: model.clipLeft

                    //asynchronous: true
                    sourceComponent: {
                        // console.log("modelClipWidth: " + modelClipWidth
                        //             + ", modelClipLeft: " + modelClipLeft
                        //             + ", root.width: " + root.width)

                        if (modelClipWidth < 24) {
                            return dymmyComp
                        }

                        return clipComp
                    }
                }
            }
        }
    }

    Component {
        id: dymmyComp
        Rectangle {
            anchors.fill: parent
            color: modelClipColor

            Rectangle {
                id: header
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right

                height: 20
                color: modelClipColor
            }
        }
    }

    Component {
        id: clipComp

        ClipItem {

            // height: parent.height
            // width: modelClipWidth
            // x: modelClipLeft

            anchors.fill: parent

            context: root.context
            title: modelClipTitle
            clipColor: modelClipColor
            clipKey: modelClipKey
            clipSelected: clipsModel.selectedClipIdx === modelIndex
            collapsed: trackViewState.isTrackCollapsed

            dragMaximumX: modelClipMoveMaximumX + borderWidth
            dragMinimumX: modelClipMoveMinimumX - borderWidth

            onPositionChanged: function(x) {
                model.clipLeft = x
            }

            onRequestSelected: {
                clipsModel.selectClip(modelIndex)
            }

            onTitleEditStarted: {
                clipsModel.selectClip(modelIndex)
            }

            onTitleEditAccepted: function(newTitle) {
                model.clipTitle = newTitle
                clipsModel.resetSelectedClip()
            }

            onTitleEditCanceled: {
                clipsModel.resetSelectedClip()
            }
        }
    }

    Rectangle {
        id: selRect
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#8EC9FF"
        opacity: 0.4
        visible: root.isDataSelected

        x: root.context.timeToPosition(root.context.selectionStartTime)
        width: root.context.timeToPosition(root.context.selectionEndTime) - x
    }

    MouseArea {
        id: dragArea

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 4

        cursorShape: Qt.SizeVerCursor

        onPressed: {
            root.interactionStarted()
        }

        onPositionChanged: function(mouse) {
            mouse.accepted = true
            trackViewState.changeTrackHeight(mouse.y)
        }

        onReleased: {
            root.interactionEnded()
        }
    }

    SeparatorLine { id: sep; anchors.bottom: parent.bottom }
}
