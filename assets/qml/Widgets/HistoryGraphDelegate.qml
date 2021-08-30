

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
import QtCharts 2.3
import QtQuick.Layouts 1.3

import SerialStudio 1.0

Window {
    id: root

    property double scalefactor: 1.01
    property int graphId: -1
    property alias sellinearr: chartView.linearr
    spacing: -1
    showIcon: false
    visible: opacity > 0
    opacity: enabled ? 1 : 0
    borderColor: root.headerVisible ? "#517497" : "transparent"
    property int framenumber
    property int max_value: Cpp_UI_DrawCurve.windowsize
    property double minvalue_Y
    property double maxvalue_Y
    Connections {
        target: Cpp_UI_DrawCurve

        function onSendFrameCount() {
            framenumber = Cpp_UI_DrawCurve.frameCount
            if (framenumber % Cpp_UI_DrawCurve.windowsize === 0) {
                let num = framenumber / Cpp_UI_DrawCurve.windowsize
                max_value = Cpp_UI_DrawCurve.windowsize * (num + 1) + 1
            }
        }
        function onSendHistoryEnvTemp() {
            if (root.title === "室内温度曲线") {
                for (var i = 0; i < 3; i++) {
                    Cpp_UI_DrawCurve.updateHistoryEnvTempGraph(
                                chartView.linearr[i], i)
                }
            }
            setAxisYValue()
        }

        function onSendHistoryHeatPower() {
            if (root.title === "热功率曲线") {
                for (var m = 0; m < Cpp_UI_DrawCurve.heatPowerNum; m++) {
                    Cpp_UI_DrawCurve.updateHistoryHeatPowerGraph(
                                chartView.linearr[m], m)
                }
            }
            setAxisYValue()
        }

        function onSendHistoryTemp() {
            if (root.title === "体表温度曲线") {
                for (var n = 0; n < Cpp_UI_DrawCurve.tempCurveNum; n++) {
                    Cpp_UI_DrawCurve.updateHistoryTempGraph(
                                chartView.linearr[n], n)
                }
            }
            setAxisYValue()
        }
    }

    ChartView {
        id: chartView
        animationOptions: ChartView.NoAnimation
        theme: ChartView.ChartThemeDark
        antialiasing: true
        anchors.fill: parent
        legend.visible: true
        backgroundRoundness: 0
        enabled: root.enabled
        visible: root.enabled
        backgroundColor: root.backgroundColor
        property var linearr: []

        margins {
            top: 0
            bottom: 0
            left: 0
            right: 0
        }

        ValueAxis {
            id: axisX
            min: 1
            max: max_value
            tickCount: 10
            labelsColor: "#ffffff"
            labelsFont.pointSize: 13
            labelsFont.bold: true
            labelFormat: '%d'
        }

        ValueAxis {
            id: axisY
            min: minvalue_Y
            max: maxvalue_Y
        }
    }

    Component.onCompleted: {
        if (root.title === "室内温度曲线") {
            for (var i = 0; i < Cpp_UI_DrawCurve.envCurveNum; i++) {
                let series = chartView.createSeries(chartView.SeriesTypeLine,
                                                    i + 1, axisX, axisY)
                series.useOpenGL = true
                chartView.linearr.push(series)
            }
        }
        if (root.title === "热功率曲线") {
            for (var m = 0; m < Cpp_UI_DrawCurve.heatPowerNum; m++) {
                var series = chartView.createSeries(chartView.SeriesTypeLine,
                                                    m + 1, axisX, axisY)
                series.useOpenGL = true
                chartView.linearr.push(series)
            }
        }
        if (root.title === "体表温度曲线") {
            for (var n = 0; n < Cpp_UI_DrawCurve.tempCurveNum; n++) {
                let series = chartView.createSeries(chartView.SeriesTypeLine,
                                                    n + 1, axisX, axisY)
                series.useOpenGL = true
                chartView.linearr.push(series)
            }
        }
    }

    function setAxisYValue() {
        if (root.title === "体表温度曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minHistT
            maxvalue_Y = Cpp_UI_DrawCurve.maxHistT * scalefactor
        }
        if (root.title === "热功率曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minHistHP
            maxvalue_Y = Cpp_UI_DrawCurve.maxHistHP * scalefactor
        }
        if (root.title === "室内温度曲线") {
            minvalue_Y = Cpp_UI_DrawCurve.minHistE
            maxvalue_Y = Cpp_UI_DrawCurve.maxHistE * scalefactor
        }
    }
}
