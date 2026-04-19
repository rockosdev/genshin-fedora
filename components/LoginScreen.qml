/*
    Adapted from KDE Breeze SDDM theme (01-breeze-fedora)
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import Qt5Compat.GraphicalEffects

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.keyboardindicator as KeyboardIndicator
import org.kde.kirigami as Kirigami

import org.kde.breeze.components

Item {
    id: root

    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    Kirigami.Theme.inherit: false

    property string notificationMessage

    property string timePeriod: "morning"

    LayoutMirroring.enabled: Application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    KeyboardIndicator.KeyState {
        id: capsLockState
        key: Qt.Key_CapsLock
    }

    // ── Background ──────────────────────────────────────────

    Item {
        id: wallpaper
        anchors.fill: parent
        Image {
            anchors.fill: parent
            source: Qt.resolvedUrl("../backgrounds/doorbg/" + root.timePeriod + "_bg.png")
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            smooth: true
        }
    }

    // ── Reject Animation ────────────────────────────────────

    RejectPasswordAnimation {
        id: rejectPasswordAnimation
        target: mainStack
    }

    // ── Login Screen ────────────────────────────────────────

    MouseArea {
        id: loginScreenRoot
        anchors.fill: parent

        property bool uiVisible: true
        property bool blockUI: mainStack.depth > 1 || userListComponent.mainPasswordBox.text.length > 0 || inputPanel.keyboardActive

        hoverEnabled: true
        drag.filterChildren: true
        onPressed: uiVisible = true;
        onPositionChanged: uiVisible = true;
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
            } else if (uiVisible) {
                fadeoutTimer.restart();
            }
        }
        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
                uiVisible = true;
            } else {
                fadeoutTimer.restart();
            }
        }

        Keys.onPressed: event => {
            uiVisible = true;
            event.accepted = false;
        }

        Timer {
            id: fadeoutTimer
            running: true
            interval: 60000
            onTriggered: {
                if (!loginScreenRoot.blockUI) {
                    userListComponent.mainPasswordBox.showPassword = false;
                    loginScreenRoot.uiVisible = false;
                }
            }
        }

        WallpaperFader {
            anchors.fill: parent
            state: loginScreenRoot.uiVisible ? "on" : "off"
            source: wallpaper
            mainStack: mainStack
            footer: footer
            clock: clock
        }

        DropShadow {
            id: clockShadow
            anchors.fill: clock
            source: clock
            visible: !softwareRendering && config.showClock === "true"
            radius: 7
            verticalOffset: 0.8
            samples: 15
            spread: 0.2
            color : Qt.rgba(0, 0, 0, 0.7)
            opacity: loginScreenRoot.uiVisible ? 0 : 1
            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Clock {
            id: clock
            property Item shadow: clockShadow
            visible: y > 0 && config.showClock === "true"
            anchors.horizontalCenter: parent.horizontalCenter
            y: (userListComponent.userList.y + mainStack.y)/2 - height/2
            Layout.alignment: Qt.AlignBaseline
        }

        QQC2.StackView {
            id: mainStack
            anchors {
                left: parent.left
                right: parent.right
            }
            height: root.height + Kirigami.Units.gridUnit * 3

            visible: opacity > 0

            hoverEnabled: loginScreenRoot.uiVisible ? undefined : false

            focus: true

            Timer {
                running: true
                repeat: false
                interval: 200
                onTriggered: mainStack.forceActiveFocus()
            }

            initialItem: Login {
                id: userListComponent
                userListModel: userModel
                loginScreenUiVisible: loginScreenRoot.uiVisible
                userListCurrentIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : 0
                lastUserName: userModel.lastUser
                showUserList: {
                    if (!userListModel.hasOwnProperty("count")
                        || !userListModel.hasOwnProperty("disableAvatarsThreshold")) {
                        return false
                    }

                    if (userListModel.count === 0 ) {
                        return false
                    }

                    if (userListModel.hasOwnProperty("containsAllUsers") && !userListModel.containsAllUsers) {
                        return false
                    }

                    return userListModel.count <= userListModel.disableAvatarsThreshold
                }

                notificationMessage: {
                    const parts = [];
                    if (capsLockState.locked) {
                        parts.push(i18ndc("plasma-desktop-sddm-theme", "@info:status",  "Caps Lock is on"));
                    }
                    if (root.notificationMessage) {
                        parts.push(root.notificationMessage);
                    }
                    return parts.join(" • ");
                }

                actionItemsVisible: !inputPanel.keyboardActive
                actionItems: [
                    ActionButton {
                        icon.name: "system-hibernate"
                        text: i18ndc("plasma-desktop-sddm-theme", "Suspend to disk", "Hibernate")
                        onClicked: sddm.hibernate()
                        enabled: sddm.canHibernate
                    },
                    ActionButton {
                        icon.name: "system-suspend"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button Suspend to RAM", "Sleep")
                        onClicked: sddm.suspend()
                        enabled: sddm.canSuspend
                    },
                    ActionButton {
                        icon.name: "system-reboot"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button", "Restart")
                        onClicked: sddm.reboot()
                        enabled: sddm.canReboot
                    },
                    ActionButton {
                        icon.name: "system-shutdown"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button", "Shut Down")
                        onClicked: sddm.powerOff()
                        enabled: sddm.canPowerOff
                    },
                    ActionButton {
                        icon.name: "system-user-prompt"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button For switching to a username and password prompt", "Other…")
                        onClicked: mainStack.push(userPromptComponent)
                        visible: !userListComponent.showUsernamePrompt
                    }]

                onLoginRequest: {
                    root.notificationMessage = ""
                    sddm.login(username, password, sessionButton.currentIndex)
                }
            }

            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                }
            }

            readonly property real zoomFactor: 1.5

            popEnter: Transition {
                ScaleAnimator {
                    from: mainStack.zoomFactor
                    to: 1
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 0
                    to: 1
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
            }

            popExit: Transition {
                ScaleAnimator {
                    from: 1
                    to: 1 / mainStack.zoomFactor
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 1
                    to: 0
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
            }

            pushEnter: Transition {
                ScaleAnimator {
                    from: 1 / mainStack.zoomFactor
                    to: 1
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 0
                    to: 1
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
            }

            pushExit: Transition {
                ScaleAnimator {
                    from: 1
                    to: mainStack.zoomFactor
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
                OpacityAnimator {
                    from: 1
                    to: 0
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        VirtualKeyboardLoader {
            id: inputPanel

            z: 1

            screenRoot: root
            mainStack: mainStack
            mainBlock: userListComponent
            passwordField: userListComponent.mainPasswordBox
        }

        Component {
            id: userPromptComponent
            Login {
                showUsernamePrompt: true
                notificationMessage: root.notificationMessage
                loginScreenUiVisible: loginScreenRoot.uiVisible
                fontSize: Kirigami.Theme.defaultFont.pointSize + 2

                userListModel: ListModel {
                    ListElement {
                        name: ""
                        icon: ""
                    }
                    Component.onCompleted: {
                        setProperty(0, "name", i18ndc("plasma-desktop-sddm-theme", "@info:usagetip", "Type in Username and Password"));
                        setProperty(0, "icon", Qt.resolvedUrl("faces/.face.icon"))
                    }
                }

                onLoginRequest: {
                    root.notificationMessage = ""
                    sddm.login(username, password, sessionButton.currentIndex)
                }

                actionItemsVisible: !inputPanel.keyboardActive
                actionItems: [
                    ActionButton {
                        icon.name: "system-suspend"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button Suspend to RAM", "Sleep")
                        onClicked: sddm.suspend()
                        enabled: sddm.canSuspend
                    },
                    ActionButton {
                        icon.name: "system-reboot"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button", "Restart")
                        onClicked: sddm.reboot()
                        enabled: sddm.canReboot
                    },
                    ActionButton {
                        icon.name: "system-shutdown"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button", "Shut Down")
                        onClicked: sddm.powerOff()
                        enabled: sddm.canPowerOff
                    },
                    ActionButton {
                        icon.name: "system-user-list"
                        text: i18ndc("plasma-desktop-sddm-theme", "@action:button", "List Users")
                        onClicked: mainStack.pop()
                    }
                ]
            }
        }

        DropShadow {
            id: logoShadow
            anchors.fill: logo
            source: logo
            visible: !softwareRendering && config.showlogo === "shown"
            horizontalOffset: 1
            verticalOffset: 1
            radius: 6
            samples: 14
            spread: 0.3
            color : "black"
            opacity: loginScreenRoot.uiVisible ? 0 : 1
            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Image {
            id: logo
            visible: config.showlogo === "shown"
            source: config.logo
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: footer.top
            anchors.bottomMargin: Kirigami.Units.largeSpacing
            asynchronous: true
            sourceSize.height: height
            opacity: loginScreenRoot.uiVisible ? 0 : 1
            fillMode: Image.PreserveAspectFit
            height: Math.round(Kirigami.Units.gridUnit * 3.5)
            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        RowLayout {
            id: footer
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: Kirigami.Units.smallSpacing
            }
            spacing: Kirigami.Units.smallSpacing

            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                }
            }

            PlasmaComponents3.ToolButton {
                id: virtualKeyboardButton

                text: i18ndc("plasma-desktop-sddm-theme", "Button to show/hide virtual keyboard", "Virtual Keyboard")
                icon.name: inputPanel.keyboardActive ? "input-keyboard-virtual-on" : "input-keyboard-virtual-off"
                onClicked: {
                    userListComponent.mainPasswordBox.forceActiveFocus();
                    inputPanel.showHide()
                }
                visible: false

                Layout.fillHeight: true
                containmentMask: Item {
                    parent: virtualKeyboardButton
                    anchors.fill: parent
                    anchors.leftMargin: -footer.anchors.margins
                    anchors.bottomMargin: -footer.anchors.margins
                }
            }

            KeyboardButton {
                id: keyboardButton

                onKeyboardLayoutChanged: {
                    userListComponent.mainPasswordBox.forceActiveFocus();
                }

                Layout.fillHeight: true
                containmentMask: Item {
                    parent: keyboardButton
                    anchors.fill: parent
                    anchors.leftMargin: virtualKeyboardButton.visible ? 0 : -footer.anchors.margins
                    anchors.bottomMargin: -footer.anchors.margins
                }
            }

            SessionButton {
                id: sessionButton

                onSessionChanged: {
                    userListComponent.mainPasswordBox.forceActiveFocus();
                }

                Layout.fillHeight: true
                containmentMask: Item {
                    parent: sessionButton
                    anchors.fill: parent
                    anchors.leftMargin: virtualKeyboardButton.visible || keyboardButton.visible
                        ? 0 : -footer.anchors.margins
                    anchors.bottomMargin: -footer.anchors.margins
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Battery {}
        }
    }

    // ── SDDM Connections ────────────────────────────────────

    Connections {
        target: sddm
        function onLoginFailed() {
            notificationMessage = i18ndc("plasma-desktop-sddm-theme", "@info:status", "Login Failed")
            footer.enabled = true
            mainStack.enabled = true
            userListComponent.userList.opacity = 1
            rejectPasswordAnimation.start()
        }
        function onLoginSucceeded() {
            mainStack.opacity = 0
            footer.opacity = 0
        }
    }

    onNotificationMessageChanged: {
        if (notificationMessage) {
            notificationResetTimer.start();
        }
    }

    Timer {
        id: notificationResetTimer
        interval: 3000
        onTriggered: notificationMessage = ""
    }
}
