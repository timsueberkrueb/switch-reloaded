pragma Singleton
import QtQuick 2.0

QtObject {
    function alpha(color, alpha) {
        return Qt.rgba (color.r, color.g, color.b, alpha);
    }
}
