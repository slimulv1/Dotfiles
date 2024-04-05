import PopupWindow from '../.widgethacks/popupwindow.js';
import SidebarRight from "./sideright.js";

export default () => PopupWindow({
    keymode: 'exclusive',
    anchor: ['right', 'top', 'bottom'],
    name: 'sideright',
    layer: 'overlay',
    child: SidebarRight(),
});
