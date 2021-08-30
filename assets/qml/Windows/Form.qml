import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    anchors.fill: parent
    color: app.windowBackgroundColor
    property int column_width: (stockTable.width - firstColumWidth) / 29
    property int firstColumWidth: 90
    Connections {
        target: Cpp_UI_DrawCurve
        function onSendCurTableTemp() {
            var temps = Cpp_UI_DrawCurve.curTableTemp
            for (var i = 0; i < temps.length; i++) {
                libraryModel.setProperty(0, "c_" + (i + 2).toString(),
                                         temps[i].toString())
            }
        }
    }

    ColumnLayout {
        x: 2 * app.spacing
        anchors.fill: parent
        spacing: app.spacing * 2
        anchors.margins: app.spacing * 1.5
        TableView {
            id: stockTable
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 10
            style: TableViewStyle {
                id: tstyle
                backgroundColor: app.windowBackgroundColor
                alternateBackgroundColor: app.windowBackgroundColor
                textColor: "white"

                // 设置TableView的头部
                headerDelegate: Canvas {
//                    implicitWidth: 90
                    implicitHeight: 32
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.lineWidth = 2
                        ctx.strokeStyle = "black"
                        ctx.fillStyle = "white"
                        ctx.beginPath()
                        ctx.rect(0, 0, width, height)
                        ctx.stroke()
                        ctx.font = "14pt sans-serif"
                        ctx.textAlign = 'right'
                        ctx.textBaseLine = "middle"
                        ctx.fillText(styleData.value, width - 2,
                                     height / 2 + 10)
                    }
                }

                // 设置行
                rowDelegate: Rectangle {
                    height: 30
                    color: app.windowBackgroundColor
                }

                // 设置单元格
                itemDelegate: Rectangle {
                    id: textRect
                    border.width: 1
                    border.color: "black"
                    color: app.windowBackgroundColor
                    TextInput {
                        id: txt
                        color: "white"
                        anchors.fill: parent
                        text: styleData.value
                        font.pointSize: 13
                        selectByMouse: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        validator: RegExpValidator {
                            regExp: /[0-9]|[0-9][\.][0-9]|[0-9][0-9]|[0-9][0-9][\.][0-9]/
                        }

                        onTextChanged: {
                            if (styleData.row === 1) {
                                libraryModel.setProperty(1,"c_" + (styleData.column + 1).toString(), text)
                            }
                        }
                    }
                }
            }

            TableViewColumn {
                role: "c_1"
                title: "区域"
                width: firstColumWidth
                movable: false
            }
            TableViewColumn {
                role: "c_2"
                title: "1"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_3"
                title: "2"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_4"
                title: "3"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_5"
                title: "4"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_6"
                title: "5"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_7"
                title: "6"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_8"
                title: "7"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_9"
                title: "8"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_10"
                title: "9"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_11"
                title: "10"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_12"
                title: "11"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_13"
                title: "12"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_14"
                title: "13"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_15"
                title: "14"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_16"
                title: "15"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_17"
                title: "16"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_18"
                title: "17"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_19"
                title: "18"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_20"
                title: "19"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_21"
                title: "20"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_22"
                title: "21"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_23"
                title: "22"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_24"
                title: "23"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_25"
                title: "24"
                width: column_width
                movable: false
            }
            TableViewColumn {
                role: "c_26"
                title: "25"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_27"
                title: "26"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_28"
                title: "27"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_29"
                title: "28"
                width: column_width
                movable: false
            }

            TableViewColumn {
                role: "c_30"
                title: "29"
                width: column_width
                movable: false
            }

            ListModel {
                id: libraryModel
                Component.onCompleted: {
                    append({
                               "c_1": "当前温度",
                               "c_2": '',
                               "c_3": '',
                               "c_4": '',
                               "c_5": '',
                               "c_6": '',
                               "c_7": '',
                               "c_8": '',
                               "c_9": '',
                               "c_10": '',
                               "c_11": '',
                               "c_12": '',
                               "c_13": '',
                               "c_14": '',
                               "c_15": '',
                               "c_16": '',
                               "c_17": '',
                               "c_18": '',
                               "c_19": '',
                               "c_20": '',
                               "c_21": '',
                               "c_22": '',
                               "c_23": '',
                               "c_24": '',
                               "c_25": '',
                               "c_26": '',
                               "c_27": '',
                               "c_28": '',
                               "c_29": '',
                               "c_30": ''
                           })
                    append({
                               "c_1": "目标温度",
                               "c_2": '30',
                               "c_3": '30',
                               "c_4": '30',
                               "c_5": '30',
                               "c_6": '30',
                               "c_7": '30',
                               "c_8": '30',
                               "c_9": '30',
                               "c_10": '30',
                               "c_11": '30',
                               "c_12": '30',
                               "c_13": '30',
                               "c_14": '30',
                               "c_15": '30',
                               "c_16": '30',
                               "c_17": '30',
                               "c_18": '30',
                               "c_19": '30',
                               "c_20": '30',
                               "c_21": '30',
                               "c_22": '30',
                               "c_23": '30',
                               "c_24": '30',
                               "c_25": '30',
                               "c_26": '30',
                               "c_27": '30',
                               "c_28": '30',
                               "c_29": '30',
                               "c_30": '30'
                           })
                }
            }

            model: libraryModel
        }

        Rectangle {
            id: btnrect
            Layout.fillWidth: true
            height: 40
            color: app.windowBackgroundColor
            Button {
                id: okbtn
                anchors.right: parent.right
                text: "确认"
                onClicked: {
                    let temstr = getTempStrList()
                    Cpp_UI_FormData.sendTemps(temstr)
                }
            }
        }
    }
    function getTempStrList() {
        let start_str = "/*SET T: "
        let end_str = "*/"
        for (var i = 0; i < Cpp_UI_DrawCurve.tempCurveNum; i++) {
            if (libraryModel.get(1)["c_" + (i + 2)].toString() === "") {
                Cpp_UI_FormData.sendWarningMess()
                break
            }
            if (i < (Cpp_UI_DrawCurve.tempCurveNum - 1)) {
                let channel_num = (i + 1) < 10 ? ('0' + (i + 1).toString(
                                                      )) : (i + 1).toString()
                let channel_str = (channel_num + " " + libraryModel.get(
                                       1)["c_" + (i + 2)].toString() + ",")
                start_str = start_str + channel_str
            }

            if (i === (Cpp_UI_DrawCurve.tempCurveNum - 1)) {
                let channel_str = ((i + 1).toString() + " " + libraryModel.get(
                                       1)["c_" + (i + 2)].toString())
                start_str = start_str + channel_str
            }
        }
        let set_order = start_str + end_str
        return set_order
    }
}
