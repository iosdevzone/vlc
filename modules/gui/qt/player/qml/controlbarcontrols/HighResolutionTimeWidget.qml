/*****************************************************************************
 * Copyright (C) 2021 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

import QtQuick 2.11
import QtQuick.Controls 2.4

import org.videolan.vlc 0.1

import "qrc:///player/"
import "qrc:///widgets/" as Widgets
import "qrc:///style/"


Control {
    id: highResolutionTimeWidget

    property bool paintOnly: false
    property VLCColors colors: VLCStyle.colors

    padding: VLCStyle.focus_border

    Keys.priority: Keys.AfterItem
    Keys.onPressed: Navigation.defaultKeyAction(event)

    function _adjustSMPTETimer(add) {
        if (typeof toolbarEditor !== "undefined") // FIXME: Can't use paintOnly because it is set later
            return

        if (add === true)
            player.requestAddSMPTETimer()
        else if (add === false)
            player.requestRemoveSMPTETimer()
    }

    Component.onCompleted: {
        _adjustSMPTETimer(true)
    }

    Component.onDestruction: {
        _adjustSMPTETimer(false)
    }

    background: Widgets.AnimatedBackground {
        active: visualFocus
        activeBorderColor: colors.bgFocus
    }

    contentItem: Item {
        implicitHeight: smpteTimecodeMetrics.height
        implicitWidth: smpteTimecodeMetrics.width

        Widgets.MenuLabel {
            id: label
            anchors.fill: parent

            text: paintOnly ? "00:00:00:00" : player.highResolutionTime
            color: colors.text

            horizontalAlignment: Text.AlignHCenter
        }

        TextMetrics {
            id: smpteTimecodeMetrics
            font: label.font
            text: "-00:00:00:00-"
        }
    }
}