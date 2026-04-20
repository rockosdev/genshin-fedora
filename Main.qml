import QtQuick
import QtMultimedia
import org.kde.kirigami as Kirigami

FocusScope {
    id: root
    width: Screen.width
    height: Screen.height

    property string stage: "idle"
    property string timePeriod: getTimePeriod()
    property int currentTrack: 0

    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    Kirigami.Theme.inherit: false

    // ── Time Period ──────────────────────────────────────────

    function getTimePeriod() {
        var h = new Date().getHours()
        if (h >= 6 && h < 12) return "morning"
        if (h >= 12 && h < 18) return "afternoon"
        return "night"
    }

    // ── Music Playlist ───────────────────────────────────────

    ListModel {
        id: playlist
        ListElement { file: "ad_oblivione.mp3" }
        ListElement { file: "ambiance.mp3" }
        ListElement { file: "another_hopeful_tomorrow.mp3" }
        ListElement { file: "ballad_of_many_waters.mp3" }
        ListElement { file: "blue_dream.mp3" }
        ListElement { file: "clear_sky_over_liyue.mp3" }
        ListElement { file: "enchanting_bedtime_stories.mp3" }
        ListElement { file: "finale_of_the_snowtomb.mp3" }
        ListElement { file: "glistening_shards.mp3" }
        ListElement { file: "her_serenity.mp3" }
        ListElement { file: "moonlike_smile.mp3" }
        ListElement { file: "snow_buried_tales.mp3" }
        ListElement { file: "spin_of_the_ice_crystals.mp3" }
        ListElement { file: "the_flourishing_past.mp3" }
        ListElement { file: "twilight_serenity.mp3" }
        ListElement { file: "unfinished_frescoes.mp3" }
    }

    // ── Background Video ─────────────────────────────────────

    MediaPlayer {
        id: bgPlayer
        property bool failed: false
        onErrorChanged: if (error !== MediaPlayer.NoError) failed = true
        source: Qt.resolvedUrl("backgrounds/" + timePeriod + "bg.mp4")
        loops: MediaPlayer.Infinite
        videoOutput: bgOutput
        audioOutput: bgAudio
    }

    AudioOutput {
        id: bgAudio
        muted: true
    }

    Image {
        id: bgFallback
        anchors.fill: parent
        source: Qt.resolvedUrl("backgrounds/failed.png")
        fillMode: Image.PreserveAspectCrop
        visible: bgPlayer.failed
    }

    VideoOutput {
        id: bgOutput
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        visible: !bgPlayer.failed && root.stage !== "login"
    }

    // ── Door Video ───────────────────────────────────────────

    MediaPlayer {
        id: doorPlayer
        property bool failed: false
        onErrorChanged: {
            if (error !== MediaPlayer.NoError) {
                failed = true
                if (root.stage === "door") root.stage = "login"
            }
        }
        source: Qt.resolvedUrl("backgrounds/doorbg/" + timePeriod + "door.webm")
        onPositionChanged: {
            if (root.stage === "door" && duration > 0 && position >= duration - 50)
                root.stage = "login"
        }
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia && root.stage === "door")
                root.stage = "login"
        }
        videoOutput: doorOutput
        audioOutput: doorAudio
    }

    AudioOutput {
        id: doorAudio
        muted: true
    }

    VideoOutput {
        id: doorOutput
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        visible: root.stage === "door" && !doorPlayer.failed
        z: 1
        layer.enabled: true
        layer.effect: ShaderEffect {
            fragmentShader: "backgrounds/doorbg/door_alpha.qsb"
        }
    }

    // ── Login Background (doorbg/{period}_bg.png) ────────────

    Image {
        id: loginBg
        anchors.fill: parent
        source: Qt.resolvedUrl("backgrounds/doorbg/" + timePeriod + "_bg.png")
        fillMode: Image.PreserveAspectCrop
        visible: root.stage === "login"
        z: 0
    }

    // ── Music Player ─────────────────────────────────────────

    MediaPlayer {
        id: musicPlayer
        audioOutput: musicAudio
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia && root.stage === "idle") {
                root.currentTrack = (root.currentTrack + 1) % playlist.count
            }
        }
    }

    AudioOutput {
        id: musicAudio
        volume: 1.0
        Behavior on volume {
            NumberAnimation { duration: 1500 }
        }
    }

    // ── Sound Effects ────────────────────────────────────────

    MediaPlayer {
        id: sfxPopup
        audioOutput: sfxAudio
        source: Qt.resolvedUrl("sounds/popup.mp3")
    }

    MediaPlayer {
        id: sfxSuccess
        audioOutput: sfxAudio
        source: Qt.resolvedUrl("sounds/succesfull.mp3")
    }

    AudioOutput {
        id: sfxAudio
        volume: 1.0
    }

    // ── Track Helpers ────────────────────────────────────────

    onCurrentTrackChanged: {
        musicPlayer.source = Qt.resolvedUrl("sounds/" + playlist.get(currentTrack).file)
        if (stage === "idle") musicPlayer.play()
    }

    function formatTrackName(filename) {
        return filename.replace(".mp3", "").replace(/_/g, " ")
            .replace(/\b\w/g, function(c) { return c.toUpperCase() })
    }

    function switchTrack(dir) {
        sfxPopup.position = 0
        sfxPopup.play()
        currentTrack = (currentTrack + dir + playlist.count) % playlist.count
    }

    // ── Stage Transitions ────────────────────────────────────

    onStageChanged: {
        if (stage === "idle") {
            bgPlayer.play()
            musicAudio.volume = 1.0
            musicPlayer.play()
        } else if (stage === "door") {
            // bg video keeps playing underneath
            musicAudio.volume = 0
            doorPlayer.play()
        } else if (stage === "login") {
            musicPlayer.stop()
            bgPlayer.stop()
        }
    }

    // ── Keyboard ─────────────────────────────────────────────

    Keys.onPressed: event => {
        if (stage === "idle") {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                stage = "door"
                event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                switchTrack(-1)
                event.accepted = true
            } else if (event.key === Qt.Key_Right) {
                switchTrack(1)
                event.accepted = true
            }
        }
    }

    // ── Init ─────────────────────────────────────────────────

    Component.onCompleted: {
        currentTrack = Math.floor(Math.random() * playlist.count)
        musicPlayer.source = Qt.resolvedUrl("sounds/" + playlist.get(currentTrack).file)
        musicPlayer.play()
        bgPlayer.play()
        doorPlayer.play()
        doorPlayer.pause()
        forceActiveFocus()
    }

    // ── IDLE STAGE ───────────────────────────────────────────

    Item {
        id: idleUI
        visible: root.stage === "idle" || opacity > 0
        opacity: root.stage === "idle" ? 1 : 0
        anchors.fill: parent
        z: 2

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }

        Column {
            anchors.centerIn: parent
            spacing: 16

            Text {
                text: formatTrackName(playlist.get(root.currentTrack).file)
                color: "white"
                font.pointSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
                style: Text.Raised
                styleColor: Qt.rgba(0, 0, 0, 0.8)
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24

                // Previous
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: prevMA.containsMouse ? Qt.rgba(1, 1, 1, 0.25) : Qt.rgba(0, 0, 0, 0.35)
                    border.color: Qt.rgba(1, 1, 1, 0.6)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "\u25C0"
                        color: "white"
                        font.pointSize: 14
                    }
                    MouseArea {
                        id: prevMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: switchTrack(-1)
                    }
                }

                // Next
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: nextMA.containsMouse ? Qt.rgba(1, 1, 1, 0.25) : Qt.rgba(0, 0, 0, 0.35)
                    border.color: Qt.rgba(1, 1, 1, 0.6)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "\u25B6"
                        color: "white"
                        font.pointSize: 14
                    }
                    MouseArea {
                        id: nextMA
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: switchTrack(1)
                    }
                }
            }

            Text {
                text: "Press Enter to continue"
                color: Qt.rgba(1, 1, 1, 0.5)
                font.pointSize: 9
                anchors.horizontalCenter: parent.horizontalCenter

                SequentialAnimation on opacity {
                    running: root.stage === "idle"
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.3; to: 1.0; duration: 1500; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.0; to: 0.3; duration: 1500; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    // ── Dim Overlay (door stage, on top of bg video) ────────

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)
        visible: root.stage === "door"
        z: 2
    }

    // ── LOGIN STAGE ──────────────────────────────────────────

    Loader {
        id: loginLoader
        active: root.stage === "login"
        visible: active
        anchors.fill: parent
        z: 3
        source: "components/LoginScreen.qml"

        opacity: 0

        onLoaded: {
            item.timePeriod = root.timePeriod
            opacity = 1
            doorPlayer.stop()
        }

        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
    }
}
