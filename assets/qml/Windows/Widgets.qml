/*
 * Copyright (c) 2020-2021 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.5 as QC15
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.12 as QtWindow

import "../Widgets" as Widgets

Control {
    id: root
    property int channelCount: 29
    property int avgTemCount: 3
    property int temCount: 29
    property int heatPowerCount: 29
    property var groups: []
    RowLayout {
        anchors.fill: parent
        spacing: app.spacing * 2
        anchors.margins: app.spacing * 1.5
        Widgets.Window {
            id: viewOptions
            gradient: true
            Layout.fillHeight: true
            Layout.minimumWidth: 240
            backgroundColor: "#121218"
            headerDoubleClickEnabled: false
            icon.source: "qrc:/icons/visibility.svg"
            title: qsTr("View")

            ScrollView {
                clip: true
                //                contentWidth: -1
                anchors.fill: parent
                anchors.margins: app.spacing
                anchors.topMargin: viewOptions.borderWidth
                anchors.bottomMargin: viewOptions.borderWidth

                ColumnLayout {
                    x: app.spacing
                    width: parent.width - 10 - 2 * app.spacing

                    Item {
                        height: app.spacing
                    }

                    Rectangle {
                        id: sidebar
                        width: 300
                        height: 900
                        property int currentItem: 0 //????????????item
                        property int spacing: 10 //???????????????
                        property bool autoExpand: false
                        property var graphs: [[], [], []]
                        property var groupNames: []
                        property var subGraphs: []

                        //??????
                        color: Qt.rgba(2 / 255, 19 / 255, 23 / 255, 128 / 255)

                        property alias model: list_view.model
                        ListView {
                            id: list_view
                            anchors.fill: parent
                            anchors.margins: 0
                            //??????+1????????????item???????????????index
                            //????????????root???currentItem????????????
                            property int itemCount: 0
                            delegate: list_delegate
                            clip: true
                        }
                        Component {
                            id: list_delegate
                            Row {
                                id: list_itemgroup
                                spacing: 0

                                //canvas ????????????????????????
                                Canvas {
                                    id: list_canvas
                                    width: item_titleicon.width + 10
                                    height: list_itemcol.height
                                    //????????????????????????????????????????????????
                                    antialiasing: false
                                    //????????????????????????????????????
                                    property bool isLastItem: (index
                                                               == parent.ListView.view.count - 1)
                                    onPaint: {
                                        var ctx = getContext("2d")
                                        var i = 0
                                        //ctx.setLineDash([4,2]); ????????????????????????????????????
                                        // setup the stroke
                                        ctx.strokeStyle = Qt.rgba(201 / 255,
                                                                  202 / 255,
                                                                  202 / 255, 1)
                                        ctx.lineWidth = 1
                                        // create a path
                                        ctx.beginPath()
                                        //?????????????????????????????????????????????-3?????????width(4)??????????????????
                                        //????????????5?????????????????????image?????????????????????????????????????????????
                                        //?????????????????????4?????????2??????????????????6????????????
                                        //????????????
                                        ctx.moveTo(width / 2,
                                                   0) //???????????????item??????????????????????????????????????????
                                        for (i = 0; i < list_itemrow.height / 2 - 5 - 3; i += 6) {
                                            ctx.lineTo(width / 2, i + 4)
                                            ctx.moveTo(width / 2, i + 6)
                                        }

                                        ctx.moveTo(width / 2 + 5,
                                                   list_itemrow.height / 2)
                                        for (i = width / 2 + 5; i < width - 3; i += 6) {
                                            ctx.lineTo(i + 4,
                                                       list_itemrow.height / 2)
                                            ctx.moveTo(i + 6,
                                                       list_itemrow.height / 2)
                                        }

                                        if (!isLastItem) {
                                            ctx.moveTo(width / 2,
                                                       list_itemrow.height / 2 + 5)
                                            for (i = list_itemrow.height / 2
                                                 + 5; i < height - 3; i += 6) {
                                                ctx.lineTo(width / 2, i + 4)
                                                ctx.moveTo(width / 2, i + 6)
                                            }
                                            //ctx.lineTo(10,height)
                                        }
                                        // stroke path
                                        ctx.stroke()
                                    }

                                    //????????????--?????????ractangle??????image
                                    Image {
                                        id: item_titleicon
                                        visible: false
                                        //?????????centerIn???????????????????????????????????????
                                        anchors.left: parent.left
                                        anchors.top: parent.top
                                        anchors.leftMargin: list_canvas.width / 2 - width / 2
                                        anchors.topMargin: list_itemrow.height / 2 - width / 2
                                        property string onSrc: "qrc:/images/on.png"
                                        property string offSrc: "qrc:/images/off.png"
                                        source: item_repeater.count ? item_sub.visible ? offSrc : onSrc : offSrc

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                if (item_repeater.count)
                                                    item_sub.visible = !item_sub.visible
                                            }
                                        }
                                    }
                                }

                                //????????????????????????item????????????listview
                                Column {
                                    id: list_itemcol
                                    //??????????????????????????????????????????text
                                    Row {
                                        id: list_itemrow
                                        width: sidebar.width
                                        height: item_text.contentHeight + sidebar.spacing
                                        anchors.margins: 0
                                        spacing: 5

                                        property int itemIndex

                                        Rectangle {
                                            property int currentItem: 0 //????????????item
                                            height: item_text.contentHeight + sidebar.spacing
                                            width: parent.width
                                            anchors.verticalCenter: parent.verticalCenter
                                            color: (currentItem === list_itemrow.itemIndex) ? Qt.rgba(101 / 255, 255 / 255, 255 / 255, 38 / 255) : "transparent"
                                            Text {
                                                id: item_text
                                                anchors.left: parent.left
                                                width: 30
                                                anchors.verticalCenter: parent.verticalCenter
                                                text: modelData.text
                                                font.pixelSize: 14
                                                font.family: "Microsoft YaHei UI"
                                                color: Qt.rgba(101 / 255, 1, 1,
                                                               1)
                                            }
                                            Switch {
                                                id: sw
                                                width: 45
                                                height: 20
                                                anchors.fill: parent
                                                Component.onCompleted: checked = true
                                                onCheckedChanged: {
                                                    if (list_itemrow.itemIndex >= 0
                                                            && list_itemrow.itemIndex
                                                            < avgTemCount) {
                                                        if (groups.length !== 1)
                                                            groups[0].sellinearr[list_itemrow.itemIndex].visible = checked
                                                    }

                                                    if (list_itemrow.itemIndex >= avgTemCount + 1
                                                            && list_itemrow.itemIndex < avgTemCount
                                                            + channelCount + 1) {
                                                        if (groups.length !== 1)
                                                            groups[1].sellinearr[list_itemrow.itemIndex - 4].visible = checked
                                                    }

                                                    if (list_itemrow.itemIndex >= 34
                                                            && list_itemrow.itemIndex < 63) {
                                                        if (groups.length !== 1)
                                                            groups[2].sellinearr[list_itemrow.itemIndex - 34].visible = checked
                                                    }
                                                }
                                            }
                                        }
                                        Component.onCompleted: {
                                            list_itemrow.itemIndex = list_view.itemCount
                                            list_view.itemCount += 1

                                            if (modelData.istitle)
                                                item_titleicon.visible = true
                                        }
                                    }

                                    //?????????
                                    Column {
                                        property int indent: 5 //??????????????????,??????????????????icon?????????
                                        id: item_sub
                                        visible: sidebar.autoExpand
                                        //??????????????????=????????????+x??????
                                        x: indent
                                        Item {
                                            width: 10
                                            height: item_repeater.contentHeight
                                            //????????????item?????????????????????Repeator????????????count
                                            ListView {
                                                id: item_repeater
                                                anchors.fill: parent
                                                anchors.margins: 0
                                                delegate: list_delegate
                                                model: modelData.subnodes
                                            }
                                        }
                                    }
                                }
                            }
                            //end list_itemgroup
                        }

                        //end list_delegate
                        Component.onCompleted: {
                            setTestDataA()
                        }

                        function setTestDataA() {
                            list_view.model = JSON.parse('[
{
"text":"??????????????????",
"istitle":true,
"subnodes":[
{"text":"???????????? 1","istitle":true},
{"text":"???????????? 2","istitle":true},
{"text":"??????????????????","istitle":true}
]
},
{
"text":"???????????????",
"istitle":true,
"subnodes":[
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"??????","istitle":true},
{"text":"??????","istitle":true}
]
},
{
"text":"??????????????????",
"istitle":true,
"subnodes":[
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"?????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"????????????","istitle":true},
{"text":"??????","istitle":true},
{"text":"??????","istitle":true},
{"text":"??????","istitle":true}
]
}
]')
                        }
                    }
                }
            }
        }

        QC15.TabView {
            id: tabview
            Layout.fillHeight: true
            Layout.fillWidth: true
            currentIndex: 0
            onCurrentIndexChanged: {
                if (currentIndex == 0) {
                    Cpp_UI_DrawCurve.sendHistEnvTempSingle()
                } else if (currentIndex == 1) {
                    Cpp_UI_DrawCurve.sendHistHPSingle()
                } else if (currentIndex == 2) {
                    Cpp_UI_DrawCurve.sendHistTempSingle()
                }
            }
            QC15.Tab {
                title: "??????????????????"
                Rectangle {
                    anchors.fill: parent
                    color: app.windowBackgroundColor
                    Widgets.HistoryGraphDelegate {
                        id: graphAvgTempDelegate
                        title: "??????????????????"
                        anchors.fill: parent
                        anchors.margins: app.spacing
                        Component.onCompleted: {
                            groups.push(graphAvgTempDelegate)
                        }
                    }
                }
            }

            QC15.Tab {
                title: "???????????????"
                Rectangle {
                    anchors.fill: parent
                    color: app.windowBackgroundColor

                    Widgets.HistoryGraphDelegate {
                        id: graphHeatPowerDelegate
                        title: "???????????????"
                        anchors.fill: parent
                        anchors.margins: app.spacing
                        Component.onCompleted: {
                            groups.push(graphHeatPowerDelegate)
                        }
                    }
                }
            }

            QC15.Tab {
                title: "??????????????????"
                Rectangle {
                    anchors.fill: parent
                    color: app.windowBackgroundColor

                    Widgets.HistoryGraphDelegate {
                        id: graphTempDelegate
                        title: "??????????????????"
                        anchors.fill: parent
                        anchors.margins: app.spacing
                        Component.onCompleted: {
                            groups.push(graphTempDelegate)
                        }
                    }
                }
            }
        }
    }
}
