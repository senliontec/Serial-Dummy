

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
import QtGraphicalEffects 1.0

import QtQuick.Window 2.12 as QtWindow

import Qt.labs.settings 1.0
import "../Widgets" as Widgets

Control {
    id: root
    property string title
    property int channelCount: 29
    property int avgTemCount: 3
    property int temCount: 29
    property int heatPowerCount: 29
    background: Rectangle {
        color: app.windowBackgroundColor
    }
    // Main layout
    ColumnLayout {
        x: 2 * app.spacing
        anchors.fill: parent
        spacing: app.spacing * 2
        anchors.margins: app.spacing * 1.5
        // Group data & graphs
        RowLayout {
            spacing: app.spacing
            Layout.fillWidth: true
            Layout.fillHeight: true
            // View options
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
                    contentWidth: -1
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
                            property int currentItem: 0 //当前选中item
                            property int spacing: 10 //项之间距离
                            property bool autoExpand: false
                            property var groups: []
                            property var graphs: [[], [], []]
                            property var groupNames: []
                            property var subGraphs: []

                            //背景
                            color: Qt.rgba(2 / 255, 19 / 255, 23 / 255,
                                           128 / 255)

                            property alias model: list_view.model
                            ListView {
                                id: list_view
                                anchors.fill: parent
                                anchors.margins: 0
                                //通过+1来给每个item一个唯一的index
                                //可以配合root的currentItem来做高亮
                                property int itemCount: 0
                                delegate: list_delegate
                                clip: true
                            }
                            Component {
                                id: list_delegate
                                Row {
                                    id: list_itemgroup
                                    spacing: 0

                                    //canvas 画项之间的连接线
                                    Canvas {
                                        id: list_canvas
                                        width: item_titleicon.width + 10
                                        height: list_itemcol.height
                                        //开了反走样，线会模糊看起来加粗了
                                        antialiasing: false
                                        //最后一项的连接线没有尾巴
                                        property bool isLastItem: (index == parent.ListView.view.count - 1)
                                        onPaint: {
                                            var ctx = getContext("2d")
                                            var i = 0
                                            //ctx.setLineDash([4,2]); 遇到个大问题，不能画虚线
                                            // setup the stroke
                                            ctx.strokeStyle = Qt.rgba(
                                                        201 / 255, 202 / 255,
                                                        202 / 255, 1)
                                            ctx.lineWidth = 1
                                            // create a path
                                            ctx.beginPath()
                                            //用短线段来实现虚线效果，判断里-3是防止width(4)超过判断长度
                                            //此外还有5的偏移是因为我image是透明背景的，为了不污染到图标
                                            //这里我是虚线长4，间隔2，加起来就是6一次循环
                                            //效果勉强
                                            ctx.moveTo(width / 2,
                                                       0) //如果第一个item虚线是从左侧拉过来，要改很多
                                            for (i = 0; i < list_itemrow.height
                                                 / 2 - 5 - 3; i += 6) {
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

                                        //项图标框--可以是ractangle或者image
                                        Image {
                                            id: item_titleicon
                                            visible: false
                                            //如果是centerIn的话展开之后就跑到中间去了
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

                                    //项内容：包含一行item和子项的listview
                                    Column {
                                        id: list_itemcol
                                        //这一项的内容，这里只加了一个text
                                        Row {
                                            id: list_itemrow
                                            width: sidebar.width
                                            height: item_text.contentHeight + sidebar.spacing
                                            anchors.margins: 0
                                            spacing: 5

                                            property int itemIndex

                                            Rectangle {
                                                property int currentItem: 0 //当前选中item
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
                                                    color: Qt.rgba(101 / 255,
                                                                   1, 1, 1)
                                                }
                                                Switch {
                                                    id: sw
                                                    width: 45
                                                    height: 20
                                                    anchors.fill: parent
                                                    palette.highlight: "#d72d60"
                                                    Component.onCompleted: checked = true
                                                    onCheckedChanged: {
                                                        if (list_itemrow.itemIndex >= 0
                                                                && list_itemrow.itemIndex
                                                                < avgTemCount) {
                                                            sidebar.graphs[0][list_itemrow.itemIndex] = checked
                                                            if (graphGenerator.itemAt(
                                                                        0) !== null) {
                                                                graphGenerator.itemAt(
                                                                            0).children[0].sellinearr[list_itemrow.itemIndex].visible = checked
                                                                if (sidebar.subGraphs[0]
                                                                        !== undefined) {
                                                                    sidebar.subGraphs[0].sellinearr[list_itemrow.itemIndex].visible = checked
                                                                }
                                                            }
                                                        }
                                                        if (list_itemrow.itemIndex == avgTemCount) {
                                                            sidebar.groups[0] = checked
                                                            if (checked) {
                                                                sidebar.check(0)
                                                            } else {
                                                                sidebar.uncheck(
                                                                            0)
                                                            }
                                                        }

                                                        if (list_itemrow.itemIndex
                                                                >= avgTemCount + 1
                                                                && list_itemrow.itemIndex
                                                                < avgTemCount + channelCount + 1) {
                                                            sidebar.graphs[1][list_itemrow.itemIndex - (avgTemCount + 1)] = checked
                                                            if (graphGenerator.itemAt(
                                                                        1) !== null) {
                                                                graphGenerator.itemAt(
                                                                            1).children[0].sellinearr[list_itemrow.itemIndex - 4].visible = checked
                                                                if (sidebar.subGraphs[1]
                                                                        !== undefined) {
                                                                    sidebar.subGraphs[1].sellinearr[list_itemrow.itemIndex - 4].visible = checked
                                                                }
                                                            }
                                                        }
                                                        if (list_itemrow.itemIndex == 33) {
                                                            sidebar.groups[1] = checked
                                                            if (checked) {
                                                                sidebar.check(1)
                                                            } else {
                                                                sidebar.uncheck(
                                                                            1)
                                                            }
                                                        }

                                                        if (list_itemrow.itemIndex >= 34
                                                                && list_itemrow.itemIndex < 63) {
                                                            sidebar.graphs[2][list_itemrow.itemIndex - 34] = checked
                                                            if (graphGenerator.itemAt(
                                                                        2) !== null) {
                                                                graphGenerator.itemAt(
                                                                            2).children[0].sellinearr[list_itemrow.itemIndex - 34].visible = checked
                                                                if (sidebar.subGraphs[2]
                                                                        !== undefined) {
                                                                    sidebar.subGraphs[2].sellinearr[list_itemrow.itemIndex - 34].visible = checked
                                                                }
                                                            }
                                                        }
                                                        if (list_itemrow.itemIndex == 63) {
                                                            sidebar.groups[2] = checked
                                                            if (checked) {
                                                                sidebar.check(2)
                                                            } else {
                                                                sidebar.uncheck(
                                                                            2)
                                                            }
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

                                        //放子项
                                        Column {
                                            property int indent: 5 //子项缩进距离,注意实际还有icon的距离
                                            id: item_sub
                                            visible: sidebar.autoExpand
                                            //上级左侧距离=小图标宽+x偏移
                                            x: indent
                                            Item {
                                                width: 10
                                                height: item_repeater.contentHeight
                                                //需要加个item来撑开，如果用Repeator获取不到count
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
                            function check(index) {
                                if (graphGenerator.itemAt(index) !== null) {
                                    graphGenerator.itemAt(
                                                index).children[0].visible = true
                                }
                            }

                            function uncheck(index) {
                                graphGenerator.itemAt(
                                            index).children[0].visible = false
                            }

                            Component.onCompleted: {
                                setTestDataA()
                                for (var n = 0; n < list_view.count; n++) {
                                    sidebar.groupNames[n] = list_view.model[n].text
                                    graphGenerator.itemAt(
                                                n).children[0].title = list_view.model[n].text
                                }
                            }

                            function setTestDataA() {
                                list_view.model = JSON.parse('[
{
"text":"室内温度曲线",
"istitle":true,
"subnodes":[
{"text":"环境温度 1","istitle":true},
{"text":"环境温度 2","istitle":true},
{"text":"平均环境温度","istitle":true}
]
},
{
"text":"热功率曲线",
"istitle":true,
"subnodes":[
{"text":"右上臂前","istitle":true},
{"text":"右上臂后","istitle":true},
{"text":"左上臂前","istitle":true},
{"text":"左上臂后","istitle":true},
{"text":"右前臂前","istitle":true},
{"text":"右前臂后","istitle":true},
{"text":"左前臂前","istitle":true},
{"text":"左前臂后","istitle":true},
{"text":"胸上部","istitle":true},
{"text":"肩背部","istitle":true},
{"text":"腹部","istitle":true},
{"text":"背中部","istitle":true},
{"text":"腰腹部","istitle":true},
{"text":"背下部","istitle":true},
{"text":"右大腿前","istitle":true},
{"text":"右大腿后","istitle":true},
{"text":"左大腿前","istitle":true},
{"text":"左大腿后","istitle":true},
{"text":"右小腹前","istitle":true},
{"text":"右臀","istitle":true},
{"text":"左小腹前","istitle":true},
{"text":"左臀","istitle":true},
{"text":"右小腿前","istitle":true},
{"text":"右小腿后","istitle":true},
{"text":"左小腿前","istitle":true},
{"text":"左小腿后","istitle":true},
{"text":"左脚","istitle":true},
{"text":"右脚","istitle":true},
{"text":"头部","istitle":true}
]
},
{
"text":"体表温度曲线",
"istitle":true,
"subnodes":[
{"text":"右上臂前","istitle":true},
{"text":"右上臂后","istitle":true},
{"text":"左上臂前","istitle":true},
{"text":"左上臂后","istitle":true},
{"text":"右前臂前","istitle":true},
{"text":"右前臂后","istitle":true},
{"text":"左前臂前","istitle":true},
{"text":"左前臂后","istitle":true},
{"text":"胸上部","istitle":true},
{"text":"肩背部","istitle":true},
{"text":"腹部","istitle":true},
{"text":"背中部","istitle":true},
{"text":"腰腹部","istitle":true},
{"text":"背下部","istitle":true},
{"text":"右大腿前","istitle":true},
{"text":"右大腿后","istitle":true},
{"text":"左大腿前","istitle":true},
{"text":"左大腿后","istitle":true},
{"text":"右小腹前","istitle":true},
{"text":"右臀","istitle":true},
{"text":"左小腹前","istitle":true},
{"text":"左臀","istitle":true},
{"text":"右小腿前","istitle":true},
{"text":"右小腿后","istitle":true},
{"text":"左小腿前","istitle":true},
{"text":"左小腿后","istitle":true},
{"text":"左脚","istitle":true},
{"text":"右脚","istitle":true},
{"text":"头部","istitle":true}
]
}
]')
                            }
                        }
                    }
                }
            }
            // Data grid
            Widgets.Window {
                id: dataWin
                gradient: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 240
                backgroundColor: "#121218"
                headerDoubleClickEnabled: false
                icon.source: "qrc:/icons/scatter-plot.svg"
                title: qsTr("Data")

                Rectangle {
                    z: 1
                    color: dataWin.borderColor
                    height: dataWin.borderWidth

                    anchors {
                        leftMargin: 5
                        rightMargin: 5
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                }
                ScrollView {
                    z: 0
                    id: _sv
                    clip: false
                    contentWidth: -1
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    anchors.margins: app.spacing * 2
                    anchors.leftMargin: app.spacing * 2 + 10

                    ColumnLayout {
                        width: _sv.width - 2 * app.spacing

                        Item {
                            Layout.minimumHeight: 10
                        }
                        GridLayout {
                            rowSpacing: 0
                            columnSpacing: 0
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            columns: 2

                            Repeater {
                                id: graphGenerator
                                model: 3
                                delegate: Item {
                                    id: graphic_item
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: graphDelegate.visible ? 600 : 0

                                    Widgets.GraphDelegate {
                                        id: graphDelegate
                                        graphId: index
                                        anchors.fill: parent
                                        anchors.margins: app.spacing
                                        onHeaderDoubleClicked: {
                                            graphWindow.show()
                                        }
                                    }

                                    QtWindow.Window {
                                        id: graphWindow
                                        width: 640
                                        height: 480
                                        minimumWidth: 320
                                        minimumHeight: 256

                                        Rectangle {
                                            anchors.fill: parent
                                            color: graph.backgroundColor
                                        }

                                        Widgets.GraphDelegate {
                                            id: graph
                                            graphId: index
                                            title: graphDelegate.title
                                            showIcon: true
                                            headerHeight: 48
                                            anchors.margins: 0
                                            anchors.fill: parent
                                            enabled: graphWindow.visible
                                            borderColor: backgroundColor
                                            headerDoubleClickEnabled: false
                                            icon.source: "qrc:/icons/chart.svg"
                                            Component.onCompleted: {
                                                sidebar.subGraphs.push(graph)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.minimumHeight: 10
                        }
                    }
                }
            }
        }
        // Title
        Rectangle {
            radius: 5
            height: 32
            Layout.fillWidth: true

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: palette.highlight
                }

                GradientStop {
                    position: 1
                    color: "#058ca7"
                }
            }

            RowLayout {
                spacing: app.spacing

                anchors {
                    left: parent.left
                    leftMargin: app.spacing
                    verticalCenter: parent.verticalCenter
                }

                Image {
                    width: sourceSize.width
                    height: sourceSize.height
                    sourceSize: Qt.size(24, 24)
                    source: "qrc:/icons/arrow-right.svg"
                    Layout.alignment: Qt.AlignVCenter

                    ColorOverlay {
                        source: parent
                        anchors.fill: parent
                        color: palette.brightText
                    }
                }

                Label {
                    font.bold: true
                    text: root.title
                    font.pixelSize: 16
                    color: palette.brightText
                    font.family: app.monoFont
                }
            }

            Label {
                font.family: app.monoFont
                color: palette.brightText
                visible: !Cpp_CSV_Player.isOpen
                text: Cpp_IO_Manager.receivedDataLength //*! Optimize this function

                anchors {
                    right: parent.right
                    rightMargin: app.spacing
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
